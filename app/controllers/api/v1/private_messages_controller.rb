module Api
  module V1
    class PrivateMessagesController < BaseController
      before_filter :authenticate_user!

      def index
        recipient = User.find(params[:id])
        private_messages = FeedItems::PrivateMessage.conversation_between(
          recipient, current_user, 10
        )
        render json: private_messages,
          each_serializer: PrivateMessageSerializer, root: 'private_messages'
      end

    end
  end
end
