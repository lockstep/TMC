class AddFreeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :free, :boolean, null: false, default: false
  end
end
