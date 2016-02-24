module PresentationsHelper
  def topics_nav
    TopicsNav.new(view: self, topics: @topics_nav).html
  end

  def breadcrumb_nav
    BreadcrumbNav.new(view: self, topics: @topics).html
  end
end
