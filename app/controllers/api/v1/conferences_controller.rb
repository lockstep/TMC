class Api::V1::ConferencesController < Api::V1::BaseController
  before_filter :authenticate_user!

  def show
    conference = Conference.find(params[:id])
    render json: conference
  end
end
