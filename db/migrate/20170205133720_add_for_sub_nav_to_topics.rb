class AddForSubNavToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :force_subnavigation, :boolean, default: false
  end
end
