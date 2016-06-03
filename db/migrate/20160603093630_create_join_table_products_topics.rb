class CreateJoinTableProductsTopics < ActiveRecord::Migration
  def self.up
    create_join_table :products, :topics do |t|
      t.index [:product_id, :topic_id]
      t.index [:topic_id, :product_id]
    end
    remove_reference :products, :topic
  end

  def self.down
    drop_table :products_topics
    add_reference :products, :topic, index: true, foreign_key: true
  end
end
