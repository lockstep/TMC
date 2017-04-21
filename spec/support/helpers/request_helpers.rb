module Requests
  module RequestHelpers
    # Add support for testing `trace` requests in RSpec.
    def trace(*args)
      reset! unless integration_session
      integration_session.__send__(:process, :trace, *args).tap do
        copy_session_variables!
      end
    end
  end
end
