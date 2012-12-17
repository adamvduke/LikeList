class UsersController < ApplicationController
  before_filter :authenticate!
  before_filter :correct_user?, :only => [:edit, :update]

  def index
    @users = User.all
  end

  def edit
    @user = User.find_by_nickname!(params[:id])
  end

  def update
    @user = User.find_by_nickname!(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = User.find_by_nickname!(params[:id])
    @likes = likes_for(@user)
  end

  private

    def correct_user?
      @user = User.find_by_nickname!(params[:id])
      redirect_back_or(root_path) unless current_user?(@user)
    end

    def likes_for(user)
      @user.likes.paginate(page:params[:page], per_page:5).order("created_time DESC")
    end
end
