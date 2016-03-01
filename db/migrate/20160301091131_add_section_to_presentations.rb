class AddSectionToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :section, :integer, default: 0
  end
end
