class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

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
    @price_range = price_range
    @topic_id = params[:topic_ids]
    @sort_by = params[:sort] || 'created_at:desc'
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
      options[:price] = price_range.split(';')[0]..price_range.split(';')[1]
      options[:topic_ids] = [params[:topic_ids]] if params[:topic_ids].present?
      options[:downloadable_id] = { not: nil }
    end
  end

  def price_range
    params[:price_range].present? ? params[:price_range] : "1;9"
  end

  def sort_by
    return { price: :asc } unless params[:sort].present?
    {}.tap do |result|
      result[params[:sort].split(':')[0]] = params[:sort].split(':')[1]
    end
  end

  def page
    params[:page] || 1
  end
end
