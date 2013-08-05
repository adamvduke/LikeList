class Like < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable

  attr_accessor :per_page

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
