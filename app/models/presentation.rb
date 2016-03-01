class Presentation < ActiveRecord::Base
  belongs_to :topic
  has_and_belongs_to_many :materials

  enum section: [:default, :language, :memory_games]

  searchkick text_middle: [:name]

  def search_data
    {
      name: name,
      topic_ids: topic.related_topic_ids,
    }
  end
end
