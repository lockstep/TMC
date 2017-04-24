module FeedItems
  extend ActiveSupport::Concern

  included do
    before_action :ensure_user_authenticated!
    before_action :set_user, only: [:send_message]
    before_action :ensure_user_belongs_to_directory, only: [:send_message, :create]
    before_action :ensure_messages_enabled, only: [:send_message]
  end

  protected

  def set_user
    @user = User.find(params[:user_id])
  end

  def feed_item_params
    params.require(:feed_item).permit(:message, :raw_image_s3_key)
  end

  def ensure_user_belongs_to_directory
    return if current_user.opted_in_to_public_directory?
    error = t('.must_be_directory_member')
    respond_to do |format|
      format.html do
        redirect_to edit_profile_users_path, alert: error
      end
      format.json do
        render json: { meta: { errors: { base: [ error ] } } }, status: 422
      end
    end
  end

  def ensure_messages_enabled
    error = nil
    if !@user.private_messages_enabled?
      error =  t('.user_messages_disabled')
    elsif !current_user.private_messages_enabled?
      error = t('.self_messages_disabled')
    elsif @user.messages_from_user_blocked?(current_user) ||
      current_user.messages_from_user_blocked?(@user)
      error = t('.messages_blocked')
    end

    return if error.nil?

    respond_to do |format|
      format.html { redirect_to :back, alert: error }
      format.json do
        render json: { meta: { errors: { base: [ error ] } } }, status: 422
      end
    end
  end

  def ensure_user_authenticated!
    return if current_user
    respond_to do |format|
      format.html do
        redirect_to new_user_session_path, alert: t('errors.must_authenticate')
      end
      format.json { head :unauthorized }
    end
  end

end
