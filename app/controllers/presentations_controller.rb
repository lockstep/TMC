class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show]
  before_action :set_topics, only: [:show, :index]

  def index
    if params[:topic_ids].nil?
      @presentations = Presentation.search(search_query,
                                           misspellings: {
                                             edit_distance: 2
                                           },
                                           aggs: [:topic_ids],
                                           page: page,
                                           per_page: 10,
                                          )
    else
      @presentations = Presentation.search(search_query,
                                           misspellings: {
                                             edit_distance: 2
                                           },
                                           where: where,
                                           aggs: [:topic_ids],
                                           page: page,
                                           per_page: 10,
                                          )
    end
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
    params[:topic_ids].split(',')
  end

  def page
    params[:page] || 1
  end

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end

  def set_topics
    @topics = Topic.includes(:children).where(parent_id: nil)
  end
end
