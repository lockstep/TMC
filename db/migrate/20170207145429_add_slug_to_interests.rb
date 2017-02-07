class AddSlugToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :slug, :string
    add_index :interests, :slug, unique: true
  end
end
