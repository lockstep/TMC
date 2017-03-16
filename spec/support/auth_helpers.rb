module Support
  module AuthHelpers
    def auth_headers(user)
      credentials = user.create_new_auth_token
      {
        "access-token": credentials['access-token'],
        "token-type":   "Bearer",
        "client":       credentials['client'],
        "expiry":       credentials['expiry'],
        "uid":          credentials['uid']
      }
    end
  end
end
