class StaticPagesController < ApplicationController
  before_action :confirm_user_logged_in, only: [:feed]

  def welcome
    # TODO: instead, confirm that user is NOT logged in
    if logged_in?
      redirect_to dashboard_url
    end
  end

  def about
  end

  def dashboard
  end

  def feed
    @feed_items = current_user.feed.paginate(page: params[:page])
  end
end
