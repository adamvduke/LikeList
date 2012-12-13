class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user?, :only => [:edit, :update]

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    @likes = likes_for(@user)
  end

  def show_nickname
    @user = User.where(nickname:params[:nickname]).first
    @likes = likes_for(@user)
    render :show
  end

  private
    def likes_for(user)
      @user.likes.paginate(page:params[:page]).order("created_time DESC")
    end
end
