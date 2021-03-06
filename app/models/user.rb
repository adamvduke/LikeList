require 'method_decorators/decorators'

class User < ActiveRecord::Base
  extend MethodDecorators

  has_many :likes, dependent: :destroy
  after_create :update_likes

  validates :uid, presence: true
  validates :nickname, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :email, presence: true, on: :update

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

  def initial_liked_media_url
    unless token.blank?
      "https://api.instagram.com/v1/users/self/media/liked/?access_token=#{token}"
    end
  end

  def liked_posts
    media_url = initial_liked_media_url
    depth = 0
    posts = []
    while media_url != nil && depth < 10 
      json = json_for(media_url)
      media_url = json ? json['pagination']['next_url'] : nil
      depth += 1
      posts.concat(json['data']) if json
    end
    posts
  end

  # See https://github.com/michaelfairley/method_decorators
  # for more information on this neato syntax
  +Retry.new(5)
  def json_for(url)
    begin
      response = RestClient.get url
      json = JSON.parse(response)
    rescue RestClient::BadRequest => ex
      Rails.logger.error([$!, $@].join("\n")) unless Rails.env.test?
      update_attribute(:token, nil)
      nil
    end
  end
end
