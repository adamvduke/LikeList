desc "Schedule update_likes for all users"
task fetch_from_instagram: :environment do
  User.all.each do |user|
    puts "Queueing update for #{user.nickname}"
    user.update_likes
  end
end