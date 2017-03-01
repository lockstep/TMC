class FeedItemsController < ApplicationController
  before_action :ensure_user_authenticated!
  before_action :set_user, only: [:send_message]
  before_action :ensure_user_belongs_to_directory, only: [ :send_message ]
  before_action :ensure_messages_enabled, only: [ :send_message ]

  def send_message
    if feed_item_params[:message].blank?
      redirect_to :back, alert: t('.message_empty')
    else
      message = FeedItems::PrivateMessage.create(
        feedable: @user, message: feed_item_params[:message], author: current_user
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

  def set_user
    @user = User.find(params[:user_id])
  end

  def feed_item_params
    params.require(:feed_item).permit(:message, :raw_image_s3_key)
  end

  def ensure_user_authenticated!
    return if user_signed_in?
    redirect_to new_user_session_path, alert: t('errors.must_authenticate')
  end

  def ensure_user_belongs_to_directory
    return if current_user.opted_in_to_public_directory?
    redirect_to edit_profile_user_path(current_user),
      alert: t('.must_be_directory_member')
  end

  def ensure_messages_enabled
    if !@user.private_messages_enabled?
      redirect_to :back, alert: t('.user_messages_disabled')
    elsif !current_user.private_messages_enabled?
      redirect_to :back, alert: t('.self_messages_disabled')
    elsif @user.messages_from_user_blocked?(current_user) ||
      current_user.messages_from_user_blocked?(@user)
      redirect_to :back, alert: t('.messages_blocked')
    end
  end

end
