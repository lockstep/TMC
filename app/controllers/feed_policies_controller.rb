class FeedPoliciesController < ApplicationController
  before_action :ensure_user_authenticated!
  before_action :set_user
  before_action :ensure_user_is_authorized

  def toggle_private_messages_enabled
    if policy = FeedPolicies::FeedItemsDisabled.find_by(feedable: @user)
      policy.destroy
      redirect_to :back, notice: t('.all_messages_enabled')
    else
      FeedPolicies::FeedItemsDisabled.create(feedable: @user)
      redirect_to :back, notice: t('.all_messages_disabled')
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def ensure_user_authenticated!
    return if user_signed_in?
    redirect_to new_user_session_path, alert: t('errors.must_authenticate')
  end

  def ensure_user_is_authorized
    return if current_user == @user
    redirect_to root_path, alert: t('errors.unauthorized')
  end

end
