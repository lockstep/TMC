class AddSlugToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :slug, :string
    add_index :presentations, :slug, unique: true
  end
end
