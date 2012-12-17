require 'method_decorators/decorators'

class User < ActiveRecord::Base
  extend MethodDecorators

  rolify
  attr_accessible :role_ids, :as => :admin
  attr_accessible :provider, :uid, :name, :email, :token, :nickname
  has_many :likes, :dependent => :destroy
  after_create :update_likes

  def self.create_with_omniauth(auth)
    user_mapper = UserMapper.new(auth)
    create!(user_mapper.attr_hash)
  end

  def to_param
    nickname
  end

  def update_likes
    liked_posts.each do |post|
      next if Like.where(user_id:self.id).where(ig_id:post["id"]).first
      likes << Like.build_with_post(post)
      save
    end
  end
  handle_asynchronously :update_likes

  def initial_liked_media_url
    "https://api.instagram.com/v1/users/self/media/liked/?access_token=#{token}"
  end

  def liked_posts
    media_url = initial_liked_media_url
    posts = []
    while media_url != nil
      json = json_for(media_url)
      media_url = json['pagination']['next_url']
      posts.concat(json['data'])
    end
    posts
  end

  # See https://github.com/michaelfairley/method_decorators
  # for more information on this neato syntax
  +Retry.new(5)
  def json_for(url)
    response = RestClient.get url
    json = JSON.parse(response)
  end

end
