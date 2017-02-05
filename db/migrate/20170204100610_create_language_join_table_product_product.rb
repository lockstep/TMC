class CreateLanguageJoinTableProductProduct < ActiveRecord::Migration
  def change
    create_join_table :left_product, :right_product,
      table_name: :alternate_language_products
  end
end
