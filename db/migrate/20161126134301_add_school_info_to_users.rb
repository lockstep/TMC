class AddSchoolInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :school_name, :string
    add_column :users, :position, :string
    add_column :users, :bambini_pilot_participant, :boolean, default: false
  end
end
