class CreateCertifications < ActiveRecord::Migration
  def change
    create_table :certifications do |t|
      t.string :name
      t.boolean :public, default: false

      t.timestamps null: false
    end
  end
end
