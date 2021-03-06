class UsersController < ApplicationController
  before_filter :authenticate!, only:[:index, :edit, :update, :destroy]
  before_filter :admin_user, only:[:index, :destroy]
  before_filter :correct_user, only:[:edit, :update]
  before_filter :ensure_ig_token, only:[:show]

  def index
    @users = User.order(:created_at)
  end

  def edit
    @user = User.find_by_nickname!(params[:id])
  end

  def update
    @user = User.find_by_nickname!(params[:id])
    if @user.update_attributes(user_params)
      if @user.email.blank?
        render :edit
      else
        redirect_to @user
      end
    else
      redirect_to edit_user_path(@user), alert: "Please enter your email address."
    end
  end

  def show
    @user = User.find_by_nickname!(params[:id])
    if params[:tagged]
      @likes = paginate(Like.tagged_with(params[:tagged]).where(user_id:@user.id))
    else
      @likes = paginate(@user.likes)
    end
    @tags = Like.where(user_id: @user.id).tag_counts_on(:tags, at_least: 5).sort_by(&:taggings_count)
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

    def ensure_ig_token
      if signed_in? && current_user.token.nil?
        sign_out
        redirect_to root_url, notice: 'Please sign in to continue.'
      end
    end

    def user_params
      params.require(:user).permit(:email)
    end
end
