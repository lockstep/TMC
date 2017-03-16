module Api
  module V1
    class Users::SessionsController < DeviseTokenAuth::SessionsController

      def create
        super do
          # Why the fsdfasdf this is necessary I don't know but for some
          # reason the default rendering via AMS sets @client_id to nil
          # or 'default' or something weird and it causes the response
          # headers not to be set.
          serializer = UserSerializer.new(@resource)
          return render json: { user: serializer.as_json['object'] }
        end
      end

    end
  end
end
