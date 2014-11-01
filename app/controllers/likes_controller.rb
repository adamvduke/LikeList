class LikesController < ApplicationController
  before_filter :authenticate!
  before_filter :correct_user?, except: [:report_broken]

  def update
    @user = User.find_by_nickname!(params[:user_id])
    @like = @user.likes.find(params[:id])
    @like.tag_list = params[:like][:tag_list]
    @like.save
  end

  def destroy
    @user = User.find_by_nickname!(params[:user_id])
    @like = @user.likes.find(params[:id])
    @like.destroy if @like
    redirect_to @user
  end

  def report_broken
    like = Like.find(params[:id])
    LikeVerificationWorker.perform_async(like.id, like.standard_res_image) if like.present?
    render json: {message: 'ok'}
  end

  private

    def correct_user?
      @user = User.find_by_nickname!(params[:user_id])
      redirect_back_or(root_path) unless current_user?(@user)
    end
end
