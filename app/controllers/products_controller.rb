class ProductsController < ApplicationController
  before_action :set_current_order, only: [:show, :index, :shipping]
  before_action :set_product, only: [:show, :shipping]

  DEFAULT_SORT = { times_sold: :desc }

  def index
    opts = {
      misspellings: { edit_distance: 1 },
      fields: [:name, :description, :vendor_organization_name, :vendor_name],
      where: search_options,
      order: sort_by,
      page: page,
      per_page: 12
    }

    # don't track when paginating, only track when query is present
    if page == 1 && search_query != '*'
      opts.merge!({
        track: { user_id: current_user.try(:id) }
      })
    end

    @results = Product.search(search_query, opts)
    @recent_products = recently_viewed
    @query = search_query == '*' ? '' : search_query
    @topic = Topic.find_by(id: topic_id)
    @sort_by =
      params[:sort] || "#{DEFAULT_SORT.keys[0]}:#{DEFAULT_SORT.values[0]}"
  end

  def show
    update_session
  end

  def change_language
    @selected_product = Product.find(params[:alternate_language_product])
    redirect_to @selected_product
  end

  def shipping
    authenticate_user!
    if current_user.address_complete?
      @shipping_cost = Shipper.get_lowest_cost(
        current_user, @product
      )
      session.delete(:calculating_shipping_for_product)
      render 'show'
    else
      session[:calculating_shipping_for_product] = @product.id
      redirect_to edit_address_user_path(current_user)
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
    @results = @product.related_products.live
  end

  def recently_viewed
    return [] if session[:recently_viewed].nil?
    products = Product.where(id: session[:recently_viewed])
    persisted_recently_viewed = session[:recently_viewed]
      .map { |id| products.find { |p| p.id == id } }.compact
    session[:recently_viewed] = persisted_recently_viewed.map { |p| p.id }
    persisted_recently_viewed
  end

  def update_session
    session[:recently_viewed] ||= []
    session[:recently_viewed].delete(@product.id)
    session[:recently_viewed].unshift(@product.id)
    session[:recently_viewed] = session[:recently_viewed].take(5)
  end

  def search_query
    # If searching a new topic, clear the query.
    return '*' if params[:topic_ids] != params[:previous_topic]
    params[:q].present? ? params[:q] : '*'
  end

  def search_options
    {}.tap do |options|
      options[:topic_ids] = [ topic_id ] if topic_id
      options[:live] = true
    end
  end

  def topic_id
    return nil unless params[:topic_ids].to_i > 0
    # NOTE: For now we've decided not to allow combined searches of topics
    # and arbitrary queries (via params[:q])
    return nil if search_query != '*'
    params[:topic_ids]
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
