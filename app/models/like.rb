class Like < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :caption, :created_time, :filter, :ig_id, :low_res_image, :standard_res_image, :thumbnail, :username, :web_url
  acts_as_taggable

  def self.build_with_post(post)
    post_mapper = PostMapper.new(post)
    new(post_mapper.attr_hash)
  end

end
