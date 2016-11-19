class AddVendorToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :vendor, index: true
  end
end
