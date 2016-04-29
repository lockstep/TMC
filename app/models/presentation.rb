class Presentation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  searchkick text_middle: [:name]

  belongs_to :topic
  has_and_belongs_to_many :products

  enum section: [:default, :language, :memory_games]

  def search_data
    {
      name: name,
      topic_ids: topic.related_topic_ids,
      section: section.to_i,
    }
  end

  private

  def slug_candidates
    [
      :name,
      [:topic, :name],
    ]
  end
end
