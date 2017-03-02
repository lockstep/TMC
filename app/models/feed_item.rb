class FeedItem < ActiveRecord::Base
  belongs_to :feedable, polymorphic: true
  belongs_to :author, class_name: 'User'

  delegate :first_name, to: :author, allow_nil: true,
    prefix: true

  validates_presence_of :message
end
