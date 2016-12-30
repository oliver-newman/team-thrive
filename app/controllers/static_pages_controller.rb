class StaticPagesController < ApplicationController
  before_action :confirm_user_logged_in, only: [:feed]
  def home
  end

  def help
  end

  def about
  end

  def feed
    @feed_items = current_user.feed.paginate(page: params[:page])
  end
end
