class AddOptedInToPublicDirectoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :opted_in_to_public_directory, :boolean, default: false
  end
end
