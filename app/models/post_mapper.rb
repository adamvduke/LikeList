require 'ostruct'

class PostMapper
  attr_accessor :post
  def initialize(post_data)
    @post = OpenStruct.new(post_data)
  end

  def attr_hash
    {
      created_time: post.created_time,
      filter: post.filter,
      ig_id: post.id,
      web_url: post.link,
      username: post.user['username'],
      low_res_image: post.images['low_resolution']['url'],
      standard_res_image: post.images['standard_resolution']['url'],
      thubmbnail: post.images['thumbnail']['url'],
      caption: post.caption.nil? ? '' : post.caption['text']
    }
  end
end
