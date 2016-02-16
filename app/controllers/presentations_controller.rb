class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show]

  def index
    @presentations = Presentation
                      .search( search_query,
                               page: params[:page] || 1,
                               per_page: 10,
                             )
  end

  def show
  end

  private

  def search_query
    params[:q] || '*'
  end

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end
end
