class DirectoryController < ApplicationController
  before_action :prepare_search_params, only: :index
  before_action :prepare_user, only: :profile

  def index
    @users = users
    @certifications = Certification.public_certifications
    @interests = Interest.public_interests
    respond_to do |format|
      format.html
      format.json do
        render json: @users, root: 'profiles',
          each_serializer: PublicUserSerializer
      end
    end
  end

  def join_directory
    session[:alternate_onboarding_function] = 'onboard_directory_member'
    redirect_to edit_profile_users_path
  end

  def profile
    unless @user
      flash[:error] = t('.user_not_found')
      return redirect_to directory_path
    end
    store_location_for(:user, directory_profile_path(@user))
    @vendor_products = @user.products_for_sale.live
    @private_messages = FeedItems::PrivateMessage.conversation_between(
      @user, current_user, 10
    )
  end

  private

  def prepare_search_params
    @search_certifications = params[:certifications] || []
    @search_interests = params[:interests] || []
    @search_positions = params[:positions] || []
    @search_countries = params[:countries] || []
    @search_query = params[:query]
  end

  def users
    return User.opted_in_to_public_directory
      .page(params[:page] || 1) unless search?
    user_ids = [
      user_ids_by_filters,
      user_ids_by_query
    ].flatten.delete_if { |item| item.nil? }
    User.opted_in_to_public_directory.where(id: user_ids.uniq)
      .page(params[:page] || 1)
  end

  def user_ids_by_filters
    return unless filter?
    user_ids = [
      user_ids_by_certifications(@search_certifications),
      user_ids_by_interests(@search_interests),
      user_ids_by_positions(@search_positions),
      user_ids_by_countries(@search_countries),
    ]
    user_ids.flatten.delete_if { |item| item.nil? }
  end

  def user_ids_by_query
    return unless query?
    query_pattern = ".*(#{params[:query].split(' ').join('|')}).*"

    certification_join = <<-SQL
      LEFT OUTER JOIN certificate_acquisitions
        ON certificate_acquisitions.user_id = users.id
      LEFT OUTER JOIN certifications
        ON certifications.id = certificate_acquisitions.certification_id
    SQL

    interest_join = <<-SQL
      LEFT OUTER JOIN personal_interests
        ON personal_interests.user_id = users.id
      LEFT OUTER JOIN interests
        ON interests.id = personal_interests.interest_id
    SQL

    or_clauses = [
      'first_name ~* ?',
      'last_name ~* ?',
      'certifications.name ~* ?',
      'interests.name ~* ?',
    ]

    User.joins(certification_join).joins(interest_join)
      .where(
        or_clauses.join(" OR "),
        query_pattern, query_pattern,
        query_pattern, query_pattern
    ).distinct.pluck(:id)
  end

  def user_ids_by_certifications(certitication_names)
    return unless certitication_names.present?
    certifications = Certification.where(
      name: certitication_names, public: true
    )
    return unless certifications.present?
    CertificateAcquisition.where(
      certification: certifications
    ).pluck(:user_id)
  end

  def user_ids_by_interests(interest_names)
    return unless interest_names.present?
    interests = Interest.where(
      name: interest_names, public: true
    )
    return unless interests.present?
    PersonalInterest.where(
      interest: interests
    ).pluck(:user_id)
  end

  def user_ids_by_positions(position_names)
    return unless position_names.present?
    User.where(
      position: position_names
    ).pluck(:id)
  end

  def user_ids_by_countries(country_names)
    return unless country_names.present?
    User.where(
      address_country: country_names
    ).pluck(:id)
  end

  def filter?
    @search_certifications.present? ||
    @search_interests.present? ||
    @search_positions.present? ||
    @search_countries.delete_if(&:empty?).present?
  end

  def query?
    params[:query].present?
  end

  def search?
    filter? || query?
  end

  def prepare_user
    @user = User.opted_in_to_public_directory
      .find_by(id: params[:user_id])
  end
end
