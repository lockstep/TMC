class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show]

  def show
  end

  private

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end
end
