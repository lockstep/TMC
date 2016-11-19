class AddMaxMinShippingToProducts < ActiveRecord::Migration
  def change
    add_column :products, :min_shipping_cost_cents, :integer
    add_column :products, :max_shipping_cost_cents, :integer
  end
end
