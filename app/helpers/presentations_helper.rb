module PresentationsHelper
  def topics_nav(controller: :presentations, active_topic_id: 1)
    TopicsNav.new(view: self,
                  controller: controller,
                  active_topic_id: active_topic_id).html
  end

  def breadcrumb_nav
    BreadcrumbNav.new(view: self, topics: @topics).html
  end
end
