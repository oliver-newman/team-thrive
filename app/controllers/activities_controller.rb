class ActivitiesController < ApplicationController
  before_action :confirm_user_logged_in, only: [:show, :new, :create, :destroy]

  def show
    @activity = Activity.find_by(id: params[:id])
  end

  def new
    @activity = current_user.activities.build
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      flash[:success] = "New activity uploaded!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :start_date, :sport,
                                     :strava_activity_id, :distance,
                                     :elevation_gain, :moving_time, :comments)
  end
end
