class LikesController < ApplicationController
  before_filter :authenticate!
  before_filter :correct_user?, :only => [:update, :destroy]

  def show
    @user = User.find(params[:user_id])
    @like = @user.likes.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @like = @user.likes.find(params[:id])
    @like.tag_list = params[:like][:tag_list]
    @like.save
    redirect_to :back
  end

  def destroy
    @user = User.find(params[:user_id])
    @like = @user.likes.find(params[:id])
    @like.destroy if @like
    redirect_to @user
  end

  private

    def correct_user?
      @user = User.find(params[:user_id])
      redirect_back_or(root_path) unless current_user?(@user)
    end
end
