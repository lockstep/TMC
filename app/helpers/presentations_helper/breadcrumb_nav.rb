module PresentationsHelper
  class BreadcrumbNav
    def initialize(view:, product:)
      @view = view
      @product = product
    end

    def html
      if @product.try(:topics).present?
        @topics = sorted_topics
      else
        @topics = []
      end
      breadcrumb
    end

    private

    attr_accessor :view, :topics
    delegate :link_to, :content_tag, :safe_join, :concat, to: :view

    def breadcrumb
      content_tag(:ol,
                  class: 'breadcrumb',
                  style: 'margin-top: 5px;',
                 ) do
        links = @topics.collect do |topic|
          breadcrumb_item_link(topic.name, topic.id)
        end
        safe_join(links.unshift(breadcrumb_item_link('Products', 0)))
      end
    end

    def breadcrumb_item_link(topic_name, topic_id)
      content_tag :li do
        unless topic_id == 0
          link_to(topic_name,
                  controller: :products,
                  topic_ids: topic_id,
                 )
        else
          link_to(topic_name, controller: :products)
        end
      end
    end

    def sorted_topics
      topic_ids = @product.topics[0].related_topic_ids
      topics = Topic.find(topic_ids).group_by(&:id)
      topic_ids.map { |i| topics[i].first }
    end
  end
end
