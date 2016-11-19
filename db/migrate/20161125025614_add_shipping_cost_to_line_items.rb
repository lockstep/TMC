class AddShippingCostToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :shipping_cost_cents, :integer
  end
end
