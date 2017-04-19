class FeedItemsController < ApplicationController
  include FeedItems

  def send_message
    if feed_item_params[:message].blank?
      redirect_to :back, alert: t('.message_empty')
    else
      message = FeedItems::PrivateMessage.create(
        feedable: @user, message: feed_item_params[:message],
        author: current_user
      )
      UsersMailer.new_private_message(message.id).deliver_later
      redirect_to :back, notice: t('.message_sent')
    end
  end

  def send_breakout_session_comment
    @feedable = BreakoutSession.find(params[:breakout_session_id])
    create_comment
  end

  def send_interest_comment
    @feedable = Interest.find(params[:interest_id])
    create_comment
  end

  private

  def create_comment
    comment = FeedItems::Comment.new(
      feedable: @feedable,
      message: feed_item_params[:message],
      raw_image_s3_key: feed_item_params[:raw_image_s3_key],
      author: current_user
    )
    if comment.save
      FeedItemImageResizeWorker.perform_async(comment.id)
      redirect_to :back, notice: t('.comment_sent')
    else
      redirect_to :back, alert: t('.comment_empty')
    end
  end

end
