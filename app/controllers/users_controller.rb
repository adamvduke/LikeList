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
    #TODO: somehow validate the email address it can't be a model validation
    # because with the way the authentication works the user instances are
    # created without email addresses initially
    @user = User.find_by_nickname!(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = User.find_by_nickname!(params[:id])
    @likes = paginate(@user.likes)
  end

  private

    def correct_user?
      @user = User.find_by_nickname!(params[:id])
      redirect_back_or(root_path) unless current_user?(@user)
    end
end
