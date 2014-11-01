class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ActsAsTaggableOn::TagsHelper

  def paginate(likes)
    per_page = params[:per_page] ||= 5
    per_page = 20 if per_page.to_i > 20
    Like.per_page = per_page
    likes.includes(:user).order("created_time DESC").page(params[:page])
  end
end
