class User < ActiveRecord::Base
  rolify
  attr_accessible :role_ids, :as => :admin
  attr_accessible :provider, :uid, :name, :email, :token, :nickname
  has_many :likes, :dependent => :destroy
  after_create :update_likes

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.token = auth['credentials']['token']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.nickname = auth['info']['nickname']
        user.email = auth['info']['email'] || ""
      end
    end
  end

  def update_likes
    liked_posts.each do |post|
      like = Like.where(user_id:self.id).where(ig_id:post["id"]).first
      like = Like.build_with_post(post) unless like
      like.user = self unless like.user
      like.save
    end
  end

  def liked_posts
    media_url = "https://api.instagram.com/v1/users/self/media/liked/?access_token=#{token}"
    posts = []
    while media_url != nil
      json = json_for(media_url)
      media_url = json['pagination']['next_url']
      posts.concat(json['data'])
    end
    posts
  end

  # It would be really nice to use method_decorators 'Retry.new(5) to 
  # solve the infinite loop problem
  def json_for(url)
    begin
      response = RestClient.get url
      json = JSON.parse(response)
    rescue Exception
      puts "Rescuing #{url}"
      # yeah, infinite loop, be careful
      json_for(url)
    end
  end

end
