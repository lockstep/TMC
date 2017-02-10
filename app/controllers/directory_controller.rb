class DirectoryController < ApplicationController
  before_action :prepare_search_params, only: :index

  def index
    @users = users
    @certifications = Certification.public_certifications
    @interests = Interest.public_interests
  end

  private

  def prepare_search_params
    @search_certifications = params[:certifications] || []
    @search_interests = params[:interests] || []
    @search_positions = params[:positions] || []
    @search_countries = params[:countries] || []
  end

  def users
    return User.opted_in_to_public_directory
      .page(params[:page] || 1) unless search?
    user_ids = [
      user_ids_by_certifications(@search_certifications),
      user_ids_by_interests(@search_interests),
      user_ids_by_positions(@search_positions),
      user_ids_by_countries(@search_countries),
    ]
    user_ids = user_ids.flatten.delete_if { |item| item.nil? }
    User.opted_in_to_public_directory
      .where(id: user_ids.uniq).page(params[:page] || 1)
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

  def search?
    @search_certifications.present? ||
    @search_interests.present? ||
    @search_positions.present? ||
    @search_countries.delete_if(&:empty?).present?
  end
end
