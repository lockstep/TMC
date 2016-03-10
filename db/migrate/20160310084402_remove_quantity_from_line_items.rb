class RemoveQuantityFromLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :quantity
  end
end
