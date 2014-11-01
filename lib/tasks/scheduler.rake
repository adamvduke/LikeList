desc "Schedule update_likes for all users"
task fetch_from_instagram: :environment do
  User.find_each do |user|
    puts "Queueing update for #{user.nickname}"
    LikeUpdateWorker.perform_async(user.id) unless user.token.nil?
  end
end

desc "Remove broken likes"
task remove_broken_likes: :environment do
  bulk_args = Like.pluck(:id, :standard_res_image)
  Sidekiq::Client.push_bulk('queue' => 'low_priority', 'class' => LikeVerificationWorker, 'args' => bulk_args)
end

