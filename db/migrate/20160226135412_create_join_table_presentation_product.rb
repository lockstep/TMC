class CreateJoinTablePresentationProduct < ActiveRecord::Migration
  def change
    create_join_table :presentations, :products do |t|
      # t.index [:presentation_id, :product_id]
      # t.index [:product_id, :presentation_id]
    end
  end
end
