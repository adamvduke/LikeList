class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to current_user
    else
      @likes = Like.order(:created_at).includes(:user).page(params[:page] ||= 1)
      render :index
    end
  end
end
