class FeedItemsController < ApplicationController
  before_action :ensure_user_authenticated!
  before_action :ensure_user_belongs_to_directory, only: [ :send_message ]

  def send_message
    user = User.find(params[:user_id])
    if feed_item_params[:message].blank?
      redirect_to :back, alert: t('.message_empty')
    else
      message = FeedItems::PrivateMessage.create(
        feedable: user, message: feed_item_params[:message], author: current_user
      )
      UsersMailer.new_private_message(message.id).deliver_later
      redirect_to :back, notice: t('.message_sent')
    end
  end

  private

  def feed_item_params
    params.require(:feed_item).permit(:message)
  end

  def ensure_user_authenticated!
    return if user_signed_in?
    redirect_to new_user_session_path, alert: t('.must_authenticate')
  end

  def ensure_user_belongs_to_directory
    return if current_user.opted_in_to_public_directory?
    redirect_to edit_profile_user_path(current_user),
      alert: t('.must_be_directory_member')
  end

end
