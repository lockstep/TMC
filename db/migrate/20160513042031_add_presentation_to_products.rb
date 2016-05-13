class AddPresentationToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :presentation, index: true, foreign_key: true
    drop_table :presentations_products
  end
end
