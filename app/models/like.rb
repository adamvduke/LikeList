class Like < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :caption, :created_time, :filter, :ig_id, :low_res_image, :standard_res_image, :thumbnail, :username, :web_url
  acts_as_taggable

  def self.build_with_post(post)
    like_mapper = LikeMapper.new(post)
    new(like_mapper.attr_hash)
  end

  def secure_standard_res_image
    standard_res_image.gsub("http", "https")
  end

end
