if Rails.env.production?
  Rack::Timeout.timeout = 28  # seconds
end
