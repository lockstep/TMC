class AddAddressInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_line_one, :string
    add_column :users, :address_line_two, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_postal_code, :string
    add_column :users, :address_country, :string
  end
end
