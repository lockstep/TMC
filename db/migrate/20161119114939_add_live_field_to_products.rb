class AddLiveFieldToProducts < ActiveRecord::Migration
  def change
    add_column :products, :live, :boolean, default: false
  end
end
