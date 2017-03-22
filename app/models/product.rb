class Product < ActiveRecord::Base
  include Imageable
  extend FriendlyId
  has_and_belongs_to_many :related_products, class_name: 'Product',
    join_table: :related_products, foreign_key: :left_product_id,
    association_foreign_key: :right_product_id
  has_and_belongs_to_many :alternate_language_products, class_name: 'Product',
    join_table: :alternate_language_products, foreign_key: :left_product_id,
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
  scope :live, -> { where(live: true) }
  scope :with_downloadables, -> {
    where("products.id IN (SELECT product_id FROM downloadables)")
  }

  delegate :download_url, to: :downloadable, allow_nil: true
  delegate :active_shipping_location, to: :vendor
  delegate :profile_complete?, :full_name, :public_location, :bio,
    :avatar, :opted_in_to_public_directory?, :organization_name,
    to: :vendor, prefix: true, allow_nil: true

  LANGUAGES = {
    'English' => 0,
    'Spanish | Español' => 1,
    'Simplified Chinese | 简化' => 2,
    'Traditional Chinese | 傳統' => 3,
    'Blank (No Text)' => 4
  }

  def search_data
    {
      name: name,
      description: description,
      vendor_organization_name: vendor_organization_name,
      vendor_name: vendor_full_name,
      topic_ids: topic_ids_array,
      live: live,
      created_at: created_at,
      price: price,
      times_sold: times_sold
    }
  end

  def create_alternate_language_product(language_index)
    language_index = language_index.to_i
    # Ensure language doesn't already exist
    existing_alternate = alternate_language(language_index)
    return existing_alternate if existing_alternate.present?
    # Create alternate product
    base_attributes = cloneable_attributes
    base_attributes['language'] = language_index
    base_name = base_attributes['name'].split(' - ')
    base_name.pop if base_name.size > 1 && language != 0
    base_name = base_name.join(' - ')
    base_attributes['name'] =
      base_name + " - #{ LANGUAGES.key(language_index) }"
    alternate_product = Product.create(base_attributes)
    # Associate alternate product with self and other alternates
    related_products.each do |related_product|
      related_product.related_products << alternate_product
      alternate_product.related_products << related_product
    end
    alternate_language_products.each do |alternate_language_product|
      alternate_language_product.alternate_language_products << alternate_product
      alternate_product.alternate_language_products << alternate_language_product
    end
    related_products << alternate_product
    alternate_language_products << alternate_product
    alternate_product.related_products << self
    alternate_product.alternate_language_products << self
    alternate_product
  end

  def all_language_options
    [ self ].concat alternate_language_products.live
  end

  def humanized_language
    LANGUAGES.key(language)
  end

  def seller_mandated_shipping_cost?
    min_shipping_cost_cents == max_shipping_cost_cents
  end

  def sold_externally?
    recommended_vendor_url.present? || recommended_budget_vendor_url.present?
  end

  def external_resource?
    external_resource_url.present?
  end

  # This is reserved for cases where content is not "priced" and "free" but
  # in fact never has a price (e.g. products as "resources" pointing to blogs).
  def priceless?
    price == 0
  end

  def show_cta_text_with_default
    return show_cta_text if show_cta_text.present?
    "Go To Resource"
  end

  def list_cta_text_with_default
    return list_cta_text if list_cta_text.present?
    "More Info"
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

  def alternate_language(language_index)
    return self if language_index == language
    alternate_language_products.find_by(language: language_index)
  end

  def slug_candidates
    [ :name ]
  end

  def cloneable_attributes
    uncloneable_attribute_names = [
      'id', 'created_at', 'updated_at', 'slug', 'featured', 'free', 'live'
    ]
    attributes.to_hash.tap do |attrs_to_return|
      uncloneable_attribute_names.each do |uncloneable_attr|
        attrs_to_return.delete(uncloneable_attr)
      end
    end
  end
end
