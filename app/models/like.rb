class Like < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable

  attr_accessor :per_page

  def self.build_with_post(post)
    like_mapper = LikeMapper.new(post)
    new(like_mapper.attr_hash)
  end

  def secure_standard_res_image
    secure_url(standard_res_image)
  end

  def secure_low_res_image
    secure_url(low_res_image)
  end

  def secure_thumbnail
    secure_url(thumbnail)
  end

  private
    def secure_url(url)
      return url if url.try(:start_with?, 'https')
      url.try(:gsub, 'http', 'https')
    end
end
