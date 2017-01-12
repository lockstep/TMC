class AddResourceUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :external_resource_url, :text
    add_column :products, :show_cta_text, :string
    add_column :products, :list_cta_text, :string
  end
end
