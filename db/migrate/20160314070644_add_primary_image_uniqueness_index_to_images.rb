class AddPrimaryImageUniquenessIndexToImages < ActiveRecord::Migration
  def change
        add_index :images, [:imageable_id, :imageable_type, :primary], where: "images.primary = true", unique: true
  end
end
