class CreateDownloadable < ActiveRecord::Migration
  def change
    create_table :downloadables do |t|
      t.references :product, index: true, foreign_key: true
    end
  end
end
