describe OrdersMailer, type: :mailer do
  include_context 'before_after_mailer'
  fixtures :users
  fixtures :orders
  fixtures :charges
  fixtures :line_items
  fixtures :products

  let(:michelle)      { users(:michelle) }
  let(:mobile_order_completed) { orders(:mobile_order_completed) }
  let(:cards_order)   { orders(:cards_order) }
  let(:cards_charge)  { charges(:cards_charge) }
  let(:line_item) { line_items(:mobile_order_lines) }

  describe '.confirmed_order' do
    before { OrdersMailer.confirmed_order(cards_order.id).deliver_now }

    it_behaves_like "sending_email" do
      let(:recipients) { [ michelle.email] }
      let(:subject)    { "Your order is ready!" }
    end
  end

  describe '.notify_vendor' do
    before { OrdersMailer.notify_vendor(line_item.id).deliver_now }

    it "includes the recipients email" do
      expect(ActionMailer::Base.deliveries.first.to_s).to match('3108 Bent')
    end
  end
end
