class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to current_user
    else
      render :index
    end
  end
end
