class AddEmailAmountCurrencyToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :email, :string
    add_column :charges, :currency, :string
  end
end
