class PagesController < ApplicationController
  PAGES = ['home', 'about']

  def show
    if !params[:page].blank? && PAGES.include?(params[:page])
      if params[:page] == 'home'
        limit = Product.count >= 4 ? 4 : Product.count
        @featured_products = Product.order("RANDOM()").limit(limit)
      end
      render template: "pages/#{params[:page]}"
    else
      redirect_to root_path
    end
  end
end
