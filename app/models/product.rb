class Product < ActiveRecord::Base
  include Imageable
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  searchkick text_middle: [:name, :description]

  has_and_belongs_to_many :presentations
  has_one :downloadable
  scope :featured, -> { where(featured: true) }

  delegate :download_url, to: :downloadable

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
