class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :parent, class_name: 'Topic', foreign_key: 'parent_id'
  has_many :children, class_name: 'Topic', foreign_key: 'parent_id'

  has_many :presentations
  has_and_belongs_to_many :products

  def related_topic_ids
    ancestor_ids << id
  end

  def ancestor_ids(topic: self, parent_ids: [])
    return parent_ids if topic.parent.nil?
    ancestor_ids(topic: topic.parent,
                 parent_ids: parent_ids.unshift(topic.parent.id))
  end
end
