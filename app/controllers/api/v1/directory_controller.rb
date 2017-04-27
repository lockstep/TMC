class Api::V1::DirectoryController < Api::V1::BaseController
  def index
    render json: users, root: 'profiles',
      each_serializer: PublicUserSerializer,
      meta: {
        current_page: params[:page] || 1,
        per_page: 25,
        total_pages: users.total_pages
      }
  end

  private

  def users
    return User.opted_in_to_public_directory
      .page(params[:page] || 1) unless params[:query].present?
    user_ids = [ user_ids_by_query ]
      .flatten.delete_if { |item| item.nil? }
    User.opted_in_to_public_directory.where(id: user_ids.uniq)
      .page(params[:page] || 1)
  end

  def user_ids_by_query
    return unless params[:query].present?
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
end
