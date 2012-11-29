class HomeController < ApplicationController
  def index
    if current_user
      redirect_to current_user
    else
      render :index
    end
  end
end
