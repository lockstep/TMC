module PresentationsHelper
  class BreadcrumbNav
    def initialize(view:, product:)
      @view = view
      @product = product
    end

    def html
      return unless @product
      return unless @product.topic
      @topics = Topic.where(id: @product.topic.related_topic_ids)
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
        safe_join(links)
      end
    end

    def breadcrumb_item_link(topic_name, topic_id)
      content_tag :li do
        unless topic_id == 0
          link_to(topic_name,
                  controller: :presentations,
                  topic_ids: topic_id,
                 )
        else
          link_to(topic_name, controller: :presentations)
        end
      end
    end
  end
end
