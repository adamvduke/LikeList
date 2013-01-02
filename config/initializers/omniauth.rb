
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, ENV['IG_CONSUMER_KEY'], ENV['IG_CONSUMER_SECRET']
end
