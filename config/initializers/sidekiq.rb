Sidekiq.configure_server do |config|
  config.redis = {url: ENV['REDIS_PROVIDER'], namespace: "sidekiq-#{Rails.env}"}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV['REDIS_PROVIDER'], namespace: "sidekiq-#{Rails.env}"}
end
