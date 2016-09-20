class PagesController < ApplicationController
  PAGES = ['home', 'about', 'terms', 'privacy',
           'free-montessori-materials-printables']

  def show
    if !params[:page].blank? && PAGES.include?(params[:page])
      case params[:page]
      when 'home'
        @featured_products = Product.featured.limit(4)
      when 'free-montessori-materials-printables'
        @free_products = Product.free
        store_location_for(:user, request.url)
      end
      render template: "pages/#{params[:page]}"
    else
      redirect_to root_path
    end
  end
end
