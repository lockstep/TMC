module Rack
  class RejectMethods
    METHOD_BLACKLIST = %w(TRACE).freeze

    def initialize(app)
      @app = app
      @blacklist = ENV.fetch('HTTP_METHOD_BLACKLIST') { METHOD_BLACKLIST }
    end

    def call(env)
      return @app.call(env) unless @blacklist.include?(env['REQUEST_METHOD'])
      [405, {}, ["TRACE requests not allowed!\n"]]
    end
  end
end
