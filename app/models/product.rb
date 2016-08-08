class Product < ActiveRecord::Base
  include Imageable
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  searchkick text_middle: [:name, :description]

  belongs_to :presentation
  has_and_belongs_to_many :topics
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
      topic_ids: topic_ids_array,
      downloadable_id: downloadable.try(:id),
      created_at: created_at,
      price: price,
      times_sold: times_sold
    }
  end

  def topic_ids_array
    topics.blank? ?
      [] : topics.inject([]) { |arr, t| arr | t.related_topic_ids }
  end

  def topic_name
    topics[0].try(:name) || 'Digital Products'
  end

  def times_sold
    LineItem.joins(:order).merge(Order.paid).where(product: self).count
  end

  private

  def slug_candidates
    [ :name ]
  end
end
