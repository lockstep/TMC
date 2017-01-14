class AddVisualExplorationRefToTopics < ActiveRecord::Migration
  def change
    add_reference :topics, :visual_exploration, index: true, foreign_key: true
  end
end
