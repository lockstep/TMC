class Api::V1::FeedItemsController < Api::V1::BaseController
  include FeedItems

  def send_message
    if feed_item_params[:message].blank?
      render json: { meta: { errors: { message: [ t('.message_empty') ] } } },
        status: 422
    else
      message = FeedItems::PrivateMessage.create(
        feedable: @user, message: feed_item_params[:message], author: author
      )
      UsersMailer.new_private_message(message.id).deliver_later
      head :created
    end
  end

  private

  def author
    return @author if @author
    return @author = current_api_v1_user if current_api_v1_user
  end

end
