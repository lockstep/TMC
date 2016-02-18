class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show]

  def index
    @presentations = Presentation
                      .search( search_query,
                               misspellings: {
                                 edit_distance: 2
                               },
                               aggs: [:topic_ids],
                               page: page,
                               per_page: 10,
                             )
    topic_ids = @presentations.aggs["topic_ids"]["buckets"]
                              .map{ |agg| agg["key"] }
    @topics = Topic.where(id: topic_ids)
  end

  def show
  end

  private

  def search_query
    params[:q] || '*'
  end

  def where
    {
      topic_ids: topic_ids
    }
  end

  def topic_ids
    params[:topic_ids] ? params[:topic_ids].split(',') : []
  end

  def page
    params[:page] || 1
  end

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end
end
