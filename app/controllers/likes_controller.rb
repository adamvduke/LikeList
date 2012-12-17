class LikesController < ApplicationController
  before_filter :authenticate!
  before_filter :correct_user?, :only => [:update, :destroy]

  def index
    @user = User.find_by_nickname!(params[:user_id])
    if params[:tagged]
      @likes = paginate(Like.tagged_with(params[:tagged]).where(user_id:@user.id))
    else
      @likes = paginate(@user.likes)
    end
  end

  def show
    @user = User.find_by_nickname!(params[:user_id])
    @like = @user.likes.find(params[:id])
  end

  def update
    @user = User.find_by_nickname!(params[:user_id])
    @like = @user.likes.find(params[:id])
    @like.tag_list = params[:like][:tag_list]
    @like.save
    redirect_to :back
  end

  def destroy
    @user = User.find_by_nickname!(params[:user_id])
    @like = @user.likes.find(params[:id])
    @like.destroy if @like
    redirect_to @user
  end

  private

    def correct_user?
      @user = User.find_by_nickname!(params[:user_id])
      redirect_back_or(root_path) unless current_user?(@user)
    end
end
