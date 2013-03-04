class Like < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :caption, :created_time, :filter, :ig_id, :low_res_image, :standard_res_image, :thumbnail, :username, :web_url
  acts_as_taggable

  def self.build_with_post(post)
    like_mapper = LikeMapper.new(post)
    new(like_mapper.attr_hash)
  end

  %w[standard_res_image low_res_image thumbnail].each do |method|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def secure_#{method}
        #{method}.gsub("http", "https")
      end
    RUBY
  end
end
