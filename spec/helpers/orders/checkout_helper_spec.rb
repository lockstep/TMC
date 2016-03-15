describe Orders::CheckoutHelper, type: :helper do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:michelle)      { users(:michelle) }
  let(:number_cards)  { products(:number_cards) }
  let(:cards_order)   { orders(:cards_order) }

  before do
    assign(:order, Order.find(cards_order.id))
    assign(:product, Product.find(number_cards.id))
  end

  describe '#checkout_actions' do

    subject { helper.checkout_actions }

    context 'user\'s not signed in' do
      it 'display sign_in link' do
        is_expected.to include('Log in')
      end
    end

    context 'user\'s signed in' do
      before { sign_in michelle }

      it 'display stripe btn' do
        is_expected.to include('checkout.js')
      end
    end
  end
end
