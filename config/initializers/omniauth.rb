
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, ENV['IG_CONSUMER_KEY'], ENV['IG_CONSUMER_SECRET']
end

if Rails.env.production?
  OmniAuth.config.full_host = 'http://www.likelist.me'
end
