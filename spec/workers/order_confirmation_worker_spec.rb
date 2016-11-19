describe OrderConfirmationWorker do
  fixtures :users
  fixtures :orders
  fixtures :charges
  fixtures :line_items
  fixtures :products

  context 'physical material is purchased' do
    let(:michelle)      { users(:michelle) }
    let(:paul)          { users(:paul) }
    let(:shipper)       { users(:shipper) }
    let(:mobile_order)  { orders(:mobile_order_completed) }
    let(:mobile_charge) { charges(:mobile_charge) }
    let(:line_item)     { line_items(:mobile_order_lines) }
    it 'alerts the vendor and admin' do
      expect(OrdersMailer).to receive(:notify_vendor).with(line_item.id)
        .and_call_original
      OrderConfirmationWorker.new.perform(mobile_order.id)
    end
  end
end
