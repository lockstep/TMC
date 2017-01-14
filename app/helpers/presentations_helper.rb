module PresentationsHelper
  def topics_nav(controller: :presentations)
    TopicsNav.new(view: self, controller: controller).html
  end

  def explorable_link_path(explorable)
    return explorable unless explorable.is_a?(Topic)
    { controller: :products, topic_ids: explorable.id }
  end

  def explorable_link_data(explorable)
    return {} unless explorable.is_a?(Topic)
    { topic_id: explorable.id }
  end

  def breadcrumb_nav(product: nil)
    BreadcrumbNav.new(view: self, product: product).html
  end
end
