module PresentationsHelper
  class TopicsNav
    def initialize(view:, controller:)
      @view = view
      # We have < 500 topics and don't expect many more. If we see
      # a significant increase in topics moving forward we'll need
      # to index them and do this logic via an indexer.
      @all_topics = Topic.all
      Topic.set_self_or_children_have_products(@all_topics)
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
      sorted(top_level_topics).collect do |topic|
        concat(main_topic(topic))
      end
    end

    def main_topic(topic)
      content_tag :div, class: 'well' do
        main_topic_link(topic).concat(child_topic_tags(topic_children(topic)))
      end
    end

    def main_topic_link(topic)
      link_to(
        content_tag(:span, link_text(topic), class: 'name'),
        { controller: @controller, topic_ids: topic.id },
        data: { topic_id: topic.id }
      )
    end

    def child_topic_tags(children)
      content_tag :ul, class: 'category' do
        sorted(children).collect do |child_topic|
          concat(child_link(child_topic))
        end
      end
    end

    def topic_children(topic)
      @all_topics.select { |t| t.parent_id == topic.id }
    end

    def child_link(topic)
      if topic_children(topic).empty?
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
      return topic.name unless topic.self_or_children_have_products
      "• #{topic.name}"
    end

    def top_level_topics
      @all_topics.select { |topic| topic.parent_id.blank? }
    end

    def sorted(topics)
      topics.sort_by { |topic| [topic.position ? 0 : 1, topic.position] }
    end
  end
end
