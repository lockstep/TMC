module Admin
  class ProductsController < Admin::ApplicationController
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources = resources.order(created_at: :desc).page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end

    def create_alternate_language
      product = Product.find(params[:id])
      new_product = product.create_alternate_language_product(params[:language])
      redirect_to admin_product_path(new_product)
    end
  end
end
