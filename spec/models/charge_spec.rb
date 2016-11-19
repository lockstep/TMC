describe Charge, type: :model do
  fixtures :charges
  fixtures :orders
  fixtures :line_items
  fixtures :products

  describe 'hooks' do
    before do
      Sidekiq::Testing.inline!
      @order = orders(:cards_order)
      allow(OrderConfirmationWorker).to receive(:perform_async)
      allow(NotifySlackWorker).to receive(:perform_async)
    end
    it 'sends out order confirmation' do
      Charge.create!(amount: 1000, order: @order)
      expect(OrderConfirmationWorker)
        .to have_received(:perform_async).with(@order.id)
    end
    describe 'Slack notification' do
      context 'production' do
        it 'sends out Slack notification' do
          ENV['ENABLE_TRACKING'] = 'my_url'
          charge = Charge.create!(amount: 1000, order: @order)
          expect(NotifySlackWorker)
            .to have_received(:perform_async).with(charge.id)
        end
      end
      context 'staging' do
        it 'does not send out Slack notification' do
          ENV['ENABLE_TRACKING'] = nil
          Charge.create!(amount: 1000, order: @order)
          expect(NotifySlackWorker).not_to have_received(:perform_async)
        end
      end
    end
    describe 'reindexing products' do
      before do
        allow(ReindexProductsWorker).to receive(:perform_async)
      end
      it 'calls the worker with IDs array' do
        product = products(:number_cards)
        Charge.create!(amount: 1000, order: @order)
        expect(ReindexProductsWorker)
          .to have_received(:perform_async).with([product.id])
      end
    end
  end

  describe 'associations' do
    describe 'products' do
      it 'returns products for that charge' do
        charge = charges(:cards_charge)
        product_1 = products(:number_cards)
        product_2 = products(:animal_cards)
        expect(charge.products.count).to eq 2
        expect(charge.products).to include product_1
        expect(charge.products).to include product_2
      end
    end
  end

  describe '#monthly_sales' do
    it "returns the sum of this month's charges" do
      expect(Charge.monthly_sales).to be_within(20).of 820
    end
    it 'handles months with no sales' do
      expect(Charge.monthly_sales(time: 1.year.ago)).to eq 0
    end
    it 'handles older months' do
      expect(Charge.monthly_sales(time: 3.months.ago)).to eq 200
    end
  end

  describe '#total_sales' do
    it "returns the sum of all charges" do
      expect(Charge.total_sales).to be_within(20).of 1020
    end
  end
end
