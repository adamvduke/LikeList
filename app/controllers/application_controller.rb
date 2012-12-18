class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def paginate(likes)
    likes.paginate(page:params[:page], per_page:5).order("created_at DESC")
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
