class AddLanguageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :language, :integer, default: 0
  end
end
