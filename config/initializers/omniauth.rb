
if Rails.env.production?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :instagram, ENV['IG_CONSUMER_KEY'], ENV['IG_CONSUMER_SECRET']
  end
else
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :instagram, "6143c7e2ac8b4299ac6168a199a6385b", "b1ce8b9ca8a349398d7d4a3faa6b483c"
  end
end
