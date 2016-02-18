class Presentation < ActiveRecord::Base
  belongs_to :topic

  searchkick text_middle: [:name]

  def search_data
    {
      name: name,
      topic_ids: topic.related_topic_ids,
    }
  end
end
