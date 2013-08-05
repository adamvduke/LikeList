class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ActsAsTaggableOn::TagsHelper

  def paginate(likes)
    Like.per_page = params[:per_page] ||= 5
    likes.includes(:user).order("created_time DESC").page(params[:page])
  end
end
