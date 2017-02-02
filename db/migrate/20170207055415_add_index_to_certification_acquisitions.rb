class AddIndexToCertificationAcquisitions < ActiveRecord::Migration
  def change
    add_index :certificate_acquisitions, [:user_id, :certification_id]
  end
end
