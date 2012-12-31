class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def paginate(likes)
    per_page = params[:per_page] ||= 5
    likes.paginate(page:params[:page], per_page:per_page).order("created_at DESC")
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
