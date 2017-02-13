class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.string :type
      t.text :message
      t.references :feedable, polymorphic: true, index: true
      t.references :author, index: true

      t.timestamps null: false
    end
  end
end
