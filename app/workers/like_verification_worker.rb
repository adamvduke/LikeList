class LikeVerificationWorker
  include Sidekiq::Worker

  def perform(like_id, image_url)
    begin
      Rails.logger.info "Verifying like #{like_id}"
      RestClient.head(image_url)
    rescue RestClient::Forbidden, RestClient::ResourceNotFound, RestClient::ServiceUnavailable => ex
      Rails.logger.info "Like: #{like_id} caused a #{ex.class} exception"
      Rails.logger.info "URL: #{image_url}"
      Like.find(like_id).destroy
    end
  end
end
