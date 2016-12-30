class ActivitiesController < ApplicationController
  before_action :confirm_user_logged_in, only: [:new, :create, :destroy]

  def new
    @activity = current_user.activities.new
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      flash[:success] = "New activity uploaded!"
      redirect_to root_url
    end
  end

  def destroy
  end

  private

  def micropost_params
    params.require(:activity).permit(:title, :start_date, :sport,
                                     :strava_activity_id, :distance,
                                     :elevation_gain, :moving_time)
  end
end
