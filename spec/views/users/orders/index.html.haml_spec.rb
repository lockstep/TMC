require 'rails_helper'

describe "users/orders/index" do
  fixtures :users
  fixtures :orders

  let(:paul)                      { users(:paul) }
  let(:animal_cards_order)        { orders(:animal_cards_order) }

  context 'product show page' do
    before do
      assign(:user, paul)
      assign(:orders, paul.orders.paid)

      render
    end

    it "not displays unpaid orders" do
      expect(rendered).to_not match(/#{animal_cards_order.id}/)
    end
  end
end
