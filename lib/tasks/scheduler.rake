desc "Schedule update_likes for all users"
task fetch_from_instagram: :environment do
  User.all.each do |user|
    puts "Queueing update for #{user.nickname}"
    user.update_likes
  end
end

desc "Remove broken likes"
task remove_broken_likes: :environment do
  Like.all.each do |like|
    begin
      RestClient.get(like.standard_res_image)
    rescue RestClient::Forbidden
      puts "Like: #{like.id} caused a RestClient::Forbidden exception"
      puts "URL: #{like.standard_res_image}"
      like.destroy
    end
  end
end

