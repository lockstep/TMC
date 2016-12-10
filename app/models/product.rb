class Product < ActiveRecord::Base
  include Imageable
  extend FriendlyId
  has_and_belongs_to_many :related_products, class_name: 'Product',
    join_table: :related_products, foreign_key: :left_product_id,
    association_foreign_key: :right_product_id
  friendly_id :slug_candidates, use: [:slugged, :finders]
  searchkick text_middle: [:name, :description]

  belongs_to :presentation
  belongs_to :vendor, class_name: 'User'
  has_and_belongs_to_many :topics
  has_one :downloadable
  validates_presence_of :min_shipping_cost_cents, :max_shipping_cost_cents,
    if: :fulfill_via_shipment?

  scope :featured, -> { where(featured: true) }
  scope :free, -> { where(free: true) }
  scope :with_downloadables, -> {
    where("products.id IN (SELECT product_id FROM downloadables)")
  }

  delegate :download_url, to: :downloadable, allow_nil: true
  delegate :active_shipping_location, to: :vendor

  def search_data
    {
      name: name,
      description: description,
      topic_ids: topic_ids_array,
      live: live,
      created_at: created_at,
      price: price,
      times_sold: times_sold
    }
  end

  def seller_mandated_shipping_cost?
    min_shipping_cost_cents == max_shipping_cost_cents
  end

  def sold_externally?
    recommended_vendor_url.present? || recommended_budget_vendor_url.present?
  end

  def dimensions
    [ length, width, height ]
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
