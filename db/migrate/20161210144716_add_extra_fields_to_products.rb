class AddExtraFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :purpose, :text
    add_column :products, :presentation_summary, :text
    add_column :products, :youtube_url, :text
  end
end
