class LikeUpdateWorker
  include Sidekiq::Worker

  def perform(user_id)
    User.find(user_id).update_likes
  end
end
