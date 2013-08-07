class HomeController < ApplicationController
  def index
    @likes = Like.where('web_url IS NOT NULL').order(:created_at).includes(:user).page(params[:page] ||= 1)
    if signed_in?
      redirect_to current_user
    else
      render :index
    end
  end
end
