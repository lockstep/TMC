class AddExternalUrlsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :recommended_vendor_url, :text
    add_column :products, :recommended_budget_vendor_url, :text
  end
end
