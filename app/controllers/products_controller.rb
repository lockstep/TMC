class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :find_or_create_order, only: [:show, :index]

  def index
    @results = Product.search(
      search_query,
      misspellings: { edit_distance: 2 },
      fields: [:name, :description],
      where: {
        price: price_range.split(';')[0]..price_range.split(';')[1]
      },
      order: sort_by,
      page: page,
      per_page: 10
    )
    @recent_products = recently_viewed
    @query = search_query == '*' ? '' : search_query
    @price_range = price_range
    @sort_by = params[:sort] || 'price:asc'
  end

  def show
    session[:recently_viewed] ||= []
    session[:recently_viewed].delete(@product.id)
    session[:recently_viewed].unshift(@product.id)
    session[:recently_viewed] = session[:recently_viewed].take(5)
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

  def find_or_create_order
    if session[:order_id].present?
      @order = Order.find(session[:order_id]).active? ?
        Order.find(session[:order_id]) : Order.create(state: :active)
    else
      @order = Order.create(state: :active)
    end
    session[:order_id] = @order.id
  end

  def search_query
    params[:q].present? ? params[:q] : '*'
  end

  def price_range
    params[:price_range].present? ? params[:price_range] : '1;49'
  end

  def sort_by
    return { price: :asc } unless params[:sort].present?
    attribute = params[:sort].split(':')[0]
    direction = params[:sort].split(':')[1]
    result = {}
    result[attribute] = direction
    result
  end

  def page
    params[:page] || 1
  end
end
