class ActivitiesController < ApplicationController
  FUNDRAISING_START_DATE = DateTime.new(2016, 9, 1, 0, 0, 0)

  before_action :confirm_user_logged_in, only: [:show, :new, :create, :destroy]
  before_action :confirm_correct_user, only: [:destroy]

  def show
    @activity = Activity.find_by(id: params[:id])
  end

  def new
    @activity = current_user.activities.build
  end

  def upload
    @new_activity = current_user.activities.build
    @activities = current_user.strava_client.list_athlete_activities(
      before: FUNDRAISING_START_DATE
    ).select do |activity| # Filter activities
      !activity["manual"] &&
      Activity.sports.include?(activity["type"].downcase) &&
      !Activity.exists?(strava_activity_id: activity["id"])
    end
  end

  def create
    # TODO: maybe just do a separate query of the Strava API and do all the
    # attribute validations here, so that it's impossible to submit invalid 
    # activities
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      flash[:success] = "New activity uploaded!"
      redirect_to upload_path
    end
  end

  def destroy
    @activity.destroy
    user = @activity.user
    flash[:success] = "The activity has been deleted."
    redirect_to user
  end

  private

  def activity_params
    params.require(:activity).permit(:strava_activity_id, :title, :start_date,
                                     :sport, :distance, :elevation_gain,
                                     :moving_time, :comments)
  end

  def confirm_correct_user
    @activity = current_user.activities.find_by(id: params[:id])
    redirect_to root_url if @activity.nil?
  end
end
