class AddImageRawImageKeyToFeedItems < ActiveRecord::Migration
  def change
    add_attachment :feed_items, :image
    add_column :feed_items, :raw_image_s3_key, :string
  end
end
