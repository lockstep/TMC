module PresentationsHelper
  def topics_nav(controller: :presentations)
    TopicsNav.new(view: self, controller: controller).html
  end

  def breadcrumb_nav
    BreadcrumbNav.new(view: self, topics: @topics).html
  end
end
