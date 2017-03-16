class AddProviderToUsers < ActiveRecord::Migration
  def change
    # NOTE: Adding to support our version of devise_token_auth.
    # Ideally we would remove the requirement of this field
    # from the gem, but meh.
    add_column :users, :provider, :string, default: 'email'
    add_column :users, :tokens, :json
    add_column :users, :uid, :text
  end
end
