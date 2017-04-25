class Api::V1::ConferencesController < Api::V1::BaseController
  before_filter :authenticate_user!

  def show
    conference = Conference.find(params[:id])
    render json: conference
  end

  def index
    page_num = params[:page] || 1
    conferences = Conference.order(:created_at)
    conferences = conferences.page(page_num).per(15)
    render json: conferences,
      meta: {
        current_page: page_num,
        per_page: 15,
        total_pages: conferences.total_pages
      }
  end
end
