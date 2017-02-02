class ChangeUsersColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :school_name, :organization_name
  end
end
