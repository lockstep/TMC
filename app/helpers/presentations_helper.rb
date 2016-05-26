module PresentationsHelper
  def topics_nav(controller: :presentations)
    TopicsNav.new(view: self, controller: controller).html
  end

  def breadcrumb_nav(product: nil)
    BreadcrumbNav.new(view: self, product: product).html
  end
end
