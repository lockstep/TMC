class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :parent, class_name: 'Topic', foreign_key: 'parent_id'
  belongs_to :visual_exploration
  delegate :image, to: :visual_exploration, prefix: true,
    allow_nil: true
  has_many :children, class_name: 'Topic', foreign_key: 'parent_id'

  has_many :presentations
  has_and_belongs_to_many :products

  attr_accessor :self_or_children_have_products

  def self.set_self_or_children_have_products(topics)
    # This is inefficient and needs improvement but its faster than
    # hitting db queries for every topic or the indexer.
    topic_ids_with_products = Topic.joins(:products)
      .where('products.live' => true).uniq.pluck(:id)
    topics.each do |topic|
      next unless topic_ids_with_products.include?(topic.id)
      topic.set_self_and_parents_have_products(topics)
    end
  end

  def set_self_and_parents_have_products(topics)
    self.self_or_children_have_products = true
    topics.select { |topic| topic.id == parent_id }.each do |topic|
      topic.set_self_and_parents_have_products(topics)
    end
  end

  def related_topic_ids
    ancestor_ids << id
  end

  def ancestor_ids(topic: self, parent_ids: [])
    return parent_ids if topic.parent.nil?
    ancestor_ids(topic: topic.parent,
                 parent_ids: parent_ids.unshift(topic.parent.id))
  end
end
