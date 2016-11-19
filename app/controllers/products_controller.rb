class ProductsController < ApplicationController
  before_action :set_current_order, only: [:show, :index]
  before_action :set_product, only: [:show]

  DEFAULT_SORT = { times_sold: :desc }

  def index
    @results = Product.search(
      search_query,
      misspellings: { edit_distance: 1 },
      fields: [:name, :description],
      where: search_options,
      order: sort_by,
      page: page,
      per_page: 12
    )
    @recent_products = recently_viewed
    @query = search_query == '*' ? '' : search_query
    @topic = Topic.find_by(id: params[:topic_ids])
    @sort_by =
      params[:sort] || "#{DEFAULT_SORT.keys[0]}:#{DEFAULT_SORT.values[0]}"
  end

  def show
    update_session
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def recently_viewed
    return [] if session[:recently_viewed].nil?
    products = Product.find(Array(session[:recently_viewed])).group_by(&:id)
    session[:recently_viewed].map { |i| products[i].first }
  end

  def update_session
    session[:recently_viewed] ||= []
    session[:recently_viewed].delete(@product.id)
    session[:recently_viewed].unshift(@product.id)
    session[:recently_viewed] = session[:recently_viewed].take(5)
  end

  def search_query
    params[:q].present? ? params[:q] : '*'
  end

  def search_options
    {}.tap do |options|
      options[:topic_ids] = [params[:topic_ids]] if params[:topic_ids].to_i > 0
      options[:downloadable_id] = { not: nil }
    end
  end

  def sort_by
    return DEFAULT_SORT if params[:sort].blank?
    key = params[:sort].split(':')[0]
    value = params[:sort].split(':')[1]
    return DEFAULT_SORT unless %W(created_at price).include?(key) &&
      %W(desc asc).include?(value)
    {}.tap { |result| result[key] = value }
  end

  def page
    params[:page] || 1
  end
end
