class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items

  enum state: [:active, :completed]
end
