class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true
      t.text :caption
      t.boolean :primary, default: false
      t.string :s3_key

      t.timestamps null: false
    end
  end
end
