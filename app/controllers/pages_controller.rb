class PagesController < ApplicationController
  PAGES = ['home', 'about']

  def show
    if !params[:page].blank? && PAGES.include?(params[:page])
      render template: "pages/#{params[:page]}"
    else
      redirect_to root_path
    end
  end
end
