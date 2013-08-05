class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ActsAsTaggableOn::TagsHelper

  def paginate(likes)
    per_page = params[:per_page] ||= 5
    likes.paginate(page:params[:page], per_page:per_page, include: :user).order("created_time DESC")
  end
end
