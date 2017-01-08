class ActivitiesController < ApplicationController
  before_action :confirm_user_logged_in, only: [:show, :new, :create, :destroy,
                                                :dashboard, :new]
  before_action :confirm_correct_user, only: [:destroy]

  def show
    @activity = Activity.find_by(id: params[:id])
  end

  def new
    @new_activity = current_user.activities.build
    @activities = current_user.strava_client.list_athlete_activities(
      after: Activity::FUNDRAISING_START_DATE
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
      redirect_to 'new'
    end
  end

  def destroy
    @activity.destroy
    user = @activity.user
    flash[:success] = "The activity has been deleted."
    redirect_to user
  end

  def dashboard
    @user = current_user
  end

  def feed
    @feed_items = current_user.feed.paginate(page: params[:page])
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
