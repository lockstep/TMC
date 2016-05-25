class Product < ActiveRecord::Base
  include Imageable
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  searchkick text_middle: [:name, :description]

  belongs_to :presentation
  belongs_to :topic
  has_one :downloadable

  scope :featured, -> { where(featured: true) }
  scope :with_downloadables, -> {
    where("products.id IN (SELECT product_id FROM downloadables)")
  }

  delegate :download_url, to: :downloadable

  def search_data
    {
      name: name,
      description: description,
      topic_ids: topic.nil? ? [] : topic.related_topic_ids,
      created_at: created_at,
      price: price
    }
  end

  private

  def slug_candidates
    [ :name ]
  end
end
