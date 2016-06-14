describe OrdersMailer, type: :mailer do
  include_context 'before_after_mailer'
  fixtures :users
  fixtures :orders
  fixtures :charges
  fixtures :line_items

  let(:michelle)      { users(:michelle) }
  let(:cards_order)   { orders(:cards_order) }
  let(:cards_charge)  { charges(:cards_charge) }

  describe '.confirmed_order' do
    before { OrdersMailer.confirmed_order(cards_order.id).deliver_now }

    it_behaves_like "sending_email" do
      let(:recipients) { [ michelle.email] }
      let(:subject)    { "Your order is ready!" }
    end
  end
end
