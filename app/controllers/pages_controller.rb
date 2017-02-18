class PagesController < ApplicationController
  before_action :perform_preaction

  PAGES = [
    'home', 'about', 'terms', 'privacy',
    'free-montessori-materials-printables', 'bambini-pilot'
  ]

  def show
    if !params[:page].blank? && PAGES.include?(params[:page])
      case params[:page]
      when 'home'
        @featured_products = Product.featured.limit(4)
      when 'free-montessori-materials-printables'
        @free_products = Product.free
        store_location_for(:user, request.url)
      when 'bambini-pilot'
        authenticate_user!
        @user = current_user
      end
      render template: "pages/#{params[:page]}"
    else
      redirect_to root_path
    end
  end

  private

  def perform_preaction
    return if params[:preaction].blank?

    case params[:preaction]
    when 'disable_private_messages'
      user = User.find_by(id: params[:user_id])
      if user && user.email_access_token == params[:a]
        existing_policy =
          FeedPolicies::FeedItemsDisabled.find_by(feedable: user)
        return if existing_policy
        FeedPolicies::FeedItemsDisabled.create(feedable: user)
        flash.now[:notice] = t('directory.profile.all_messages_disabled')
      end
    end
  end

end
