class HomeController < ApplicationController
  def index
    @likes = Like.order(:created_at).includes(:user).page(params[:page] ||= 1)
    if signed_in?
      redirect_to current_user
    else
      render :index
    end
  end
end
