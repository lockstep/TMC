module PresentationsHelper
  def topics_nav
    TopicsNav.new(view: self, topics: @topics).html
  end

  class TopicsNav
    def initialize(view:, topics:)
      @view = view
      @topics = topics
    end

    def html
      content_tag :nav do
        safe_join(nav_content)
      end
    end

    private

    attr_accessor :view, :topics
    delegate :link_to, :content_tag, :safe_join, :concat, to: :view

    def nav_content
      topics.collect do |topic|
        concat(main_topic(topic))
      end
    end

    def main_topic(topic)
      content_tag :div, class: 'well' do
        content_tag(:h4, topic.name).concat(child_topics(topic.children))
      end
    end

    def child_topics(children)
      content_tag :ul do
        children.collect do |child_topic|
          concat(child_link(child_topic))
        end
      end
    end

    def child_link(child_topic)
      content_tag :li do
        link_to(child_topic.name,
                controller: :presentations,
                topic_ids: child_topic.id
               )
      end
    end
  end
end
