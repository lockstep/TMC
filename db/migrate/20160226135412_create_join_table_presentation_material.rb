class CreateJoinTablePresentationMaterial < ActiveRecord::Migration
  def change
    create_join_table :presentations, :materials do |t|
      # t.index [:presentation_id, :material_id]
      # t.index [:material_id, :presentation_id]
    end
  end
end
