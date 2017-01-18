require 'open-uri'

class ActivitiesController < ApplicationController
  before_action :confirm_user_logged_in, only: [:show, :new, :create, :destroy,
                                                :dashboard, :new]
  before_action :confirm_correct_user, only: [:destroy]

  def show
    @activity = Activity.find_by(id: params[:id])
  end

  def new
    @new_activity = current_user.activities.build
    @strava_activities = current_user.strava_client.list_athlete_activities(
      after: ApplicationHelper::FUNDRAISING_START_DATE
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
    # @activity.small_map = URI.parse(polyline_map_url(@activity.summary_polyline, size: 150))
    # @activity.large_map = URI.parse(polyline_map_url(@activity.summary_polyline, size: 640))
    if @activity.save
      flash[:success] = "New activity uploaded!"
      redirect_to new_activity_path
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
    params.require(:activity).permit(:strava_activity_id,
                                     :title,
                                     :start_date,
                                     :sport,
                                     :distance,
                                     :elevation_gain,
                                     :moving_time,
                                     :summary_polyline,
                                     :comments)
  end

  def polyline_map_url(polyline, size, color = "blue")
    polyline = CGI::escape(polyline.to_s)
    "https://maps.googleapis.com/maps/api/staticmap?" +
      "size=#{size}x#{size}" + 
      "&path=weight:3%7Ccolor:#{color}%7Cenc:#{polyline}" +
      "&key=#{Rails.application.secrets.GOOGLE_MAPS_KEY}"
  end

  def confirm_correct_user
    @activity = current_user.activities.find_by(id: params[:id])
    redirect_to root_url if @activity.nil?
  end
end
