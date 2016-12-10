class CreateJoinTableProductProduct < ActiveRecord::Migration
  def change
    create_join_table :left_product, :right_product,
      table_name: :related_products
  end
end
