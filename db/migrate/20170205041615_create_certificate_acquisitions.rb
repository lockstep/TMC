class CreateCertificateAcquisitions < ActiveRecord::Migration
  def change
    create_table :certificate_acquisitions do |t|
      t.integer :user_id
      t.integer :certification_id

      t.timestamps null: false
    end
  end
end
