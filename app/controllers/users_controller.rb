class UsersController < ApplicationController
  before_filter :authenticate!, only:[:index, :edit, :update, :destroy]
  before_filter :admin_user, only:[:index, :destroy]
  before_filter :correct_user, only:[:edit, :update]

  def index
    @users = User.all
  end

  def edit
    @user = User.find_by_nickname!(params[:id])
  end

  def update
    @user = User.find_by_nickname!(params[:id])
    if @user.update_attributes(params[:user])
      if @user.email.blank?
        render :edit
      else
        redirect_to @user
      end
    else
      render :edit
    end
  end

  def show
    @user = User.find_by_nickname!(params[:id])
    if params[:tagged]
      @likes = paginate(Like.tagged_with(params[:tagged]).where(user_id:@user.id))
    else
      @likes = paginate(@user.likes)
    end
    @tags = @user.likes.tag_counts_on(:tags)
  end

  def destroy
    @user = User.find_by_nickname!(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def correct_user
      user = User.find_by_nickname!(params[:id])
      redirect_to(root_path) unless current_user?(user)
    end
end
