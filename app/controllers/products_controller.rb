class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :find_or_create_order, only: [:show, :index]

  def index
    @results = Product.search(
      search_query,
      misspellings: { edit_distance: 2 },
      fields: [:name, :description],
      page: page,
      per_page: 10
    )
    @recent_products = @results
    @query = search_query == '*' ? '' : search_query
  end

  private

  def set_product
    @product = Product.find(params[:id])
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

  def page
    params[:page] || 1
  end
end
