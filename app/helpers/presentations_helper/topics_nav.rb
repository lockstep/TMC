module PresentationsHelper
  class TopicsNav
    def initialize(view:, controller:)
      @view = view
      @topics = Topic.where(parent_id: nil)
      @controller = controller
    end

    def html
      content_tag :nav do
        safe_join(nav_content)
      end
    end

    private

    attr_accessor :view
    delegate :link_to, :content_tag, :safe_join, :concat, to: :view

    def nav_content
      ordered(@topics).collect do |topic|
        concat(main_topic(topic))
      end
    end

    def main_topic(topic)
      content_tag :div, class: 'well' do
        main_topic_link(topic).concat(child_topics(topic.children))
      end
    end

    def main_topic_link(topic)
      link_to(content_tag(:span, link_text(topic), class: 'name'),
              { controller: @controller, topic_ids: topic.id },
              data: { topic_id: topic.id })
    end

    def child_topics(children)
      content_tag :ul, class: 'category' do
        ordered(children).collect do |child_topic|
          concat(child_link(child_topic))
        end
      end
    end

    def child_link(topic)
      if topic.children.empty?
        content_tag :li do
          link_to(link_text(topic),
                  { controller: @controller, topic_ids: topic.id, },
                  data: { topic_id: topic.id })
        end
      else
        main_topic(topic)
      end
    end

    def link_text(topic)
      count = Product.search(where: { topic_ids: [topic.id] }).count
      "#{topic.name} (#{count})"
    end

    def ordered(topics)
      topics.sort_by { |topic| [topic.position ? 0 : 1, topic.position] }
    end
  end
end
