class LikeListDomainRedirect

  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_HOST'].include?('heroku')
      [301, { 'Location' => 'http://www.likelist.me' }, ['Redirecting...']]
    else
      @app.call(env)
    end
  end
end
