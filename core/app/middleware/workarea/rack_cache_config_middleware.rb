module Workarea
  class RackCacheConfigMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      env['rack-cache.cache_key'] = Cache::RackCacheKey

      if request.path !~ /(jpe?g|png|ico|gif|css|js)$/
        env['rack-cache.force-pass'] = request.cookies['cache'] == 'false'
      end

      if env['workarea.visit'].present?
        env['workarea.cache_varies'] = env['workarea.visit'].varies.to_s
      end

      @app.call(env)
    end
  end
end
