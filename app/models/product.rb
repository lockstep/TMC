class Product < ActiveRecord::Base
  include Imageable
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  searchkick text_middle: [:name, :description]

  belongs_to :presentation
  has_one :downloadable
  scope :featured, -> { where(featured: true) }
  scope :with_downloadables, -> {
    where("products.id IN (SELECT product_id FROM downloadables)")
  }

  delegate :download_url, to: :downloadable
  delegate :topic, to: :presentation

  def search_data
    {
      name: name,
      description: description,
      created_at: created_at,
      price: price
    }
  end

  private

  def slug_candidates
    [ :name ]
  end
end
