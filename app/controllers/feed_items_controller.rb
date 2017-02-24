class FeedItemsController < ApplicationController
  before_action :ensure_user_authenticated!
  before_action :set_user, only: [:send_message]
  before_action :set_breakout_session, only: [:send_breakout_session_comment]
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
    if feed_item_params[:message].blank?
      redirect_to :back, alert: t('.comment_empty')
    else
      BreakoutSessionComment.create(
        feedable: @breakout_session, message: feed_item_params[:message],
        author: current_user
      )
      redirect_to :back, notice: t('.comment_sent')
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_breakout_session
    @breakout_session = BreakoutSession.find(params[:breakout_session_id])
  end

  def feed_item_params
    params.require(:feed_item).permit(:message)
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
