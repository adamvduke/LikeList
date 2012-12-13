class Like < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :caption, :created_time, :filter, :ig_id, :low_res_image, :standard_res_image, :thubmbnail, :username, :web_url
  acts_as_taggable

  def self.build_with_post(post)
    new do |like|
      like.created_time = post['created_time']
      like.filter = post['filter']
      like.username = post['user']['username']
      like.ig_id = post['id']
      like.low_res_image = post['images']['low_resolution']['url']
      like.standard_res_image = post['images']['standard_resolution']['url']
      like.thubmbnail = post['images']['thumbnail']['url']
      like.web_url = post['link']
      like.caption = post['caption']['text'] if post['caption']
    end
  end

end
