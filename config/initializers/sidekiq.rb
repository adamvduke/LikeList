# load celluloid before DynamicFetch to avoid uninitialized constant
# Celluloid::Actor error
require 'celluloid'

Sidekiq.configure_server do |config|
  config.redis = {url: ENV['REDIS_PROVIDER'], namespace: "sidekiq-#{Rails.env}"}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV['REDIS_PROVIDER'], namespace: "sidekiq-#{Rails.env}"}
end

##
# recommended by https://github.com/celluloid/celluloid/wiki/Logging
#
Celluloid.logger = Rails.logger

if Rails.env.test?
  Sidekiq.logger.level = Logger::ERROR
else
  Sidekiq.logger.level = Logger::WARN
end

