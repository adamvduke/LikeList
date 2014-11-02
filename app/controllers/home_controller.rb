class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to current_user
    else
      @likes = Like.where('web_url IS NOT NULL').order(:created_at).includes(:user).page(params[:page] ||= 1)
      render :index
    end
  end
end
