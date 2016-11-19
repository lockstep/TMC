class AddFulfillmentFlagToProducts < ActiveRecord::Migration
  def change
    add_column :products, :fulfill_via_shipment, :boolean, default: false
  end
end
