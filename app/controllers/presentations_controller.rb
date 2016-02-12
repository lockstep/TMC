class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show]

  def index
    @presentations = Presentation.order(created_at: :desc)
                                 .page(params[:page] || 1)
                                 .per(10)
  end

  def show
  end

  private

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end
end
