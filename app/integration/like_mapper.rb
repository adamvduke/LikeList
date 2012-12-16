require 'recursive_open_struct'

class LikeMapper
  attr_accessor :like
  def initialize(post_data)
    @like = RecursiveOpenStruct.new(post_data)
  end

  def attr_hash
    {
      created_time: like.created_time,
      filter: like.filter,
      ig_id: like.id,
      web_url: like.link,
      username: like.user.username,
      low_res_image: like.images.low_resolution.url,
      standard_res_image: like.images.standard_resolution.url,
      thumbnail: like.images.thumbnail.url,
      caption: like.caption.nil? ? '' : like.caption.text
    }
  end
end
