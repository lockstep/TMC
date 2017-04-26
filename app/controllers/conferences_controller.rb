class ConferencesController < ApplicationController
  before_action :set_conference, only: [:show]

  def index
    @conferences = Conference.order(:created_at)
    respond_to do |format|
      format.html
      format.json { render json: @conferences }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @conference }
    end
  end

  private

  def set_conference
    @conference = Conference.find(params[:id])
  end
end
