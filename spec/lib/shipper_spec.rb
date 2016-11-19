describe Shipper do
  fixtures :users
  fixtures :products
  before do
    @shipper = users(:shipper)
    @mobile = products(:mobile)
    @mobile.update(vendor: @shipper)
    @user = users(:paul)
  end
  xit 'returns the lowest shipping price from multiple sources' do
    res = Shipper.get_lowest_cost(@user, @mobile)
    expect(res.service_name).to match 'UPS'
  end
  context 'the apis return no shipping results' do
    before do
      @mobile.update(min_shipping_cost_cents: 1000)
      allow(Shipper).to receive(:rates_sorted_by_price).and_return([])
    end
    it 'returns the minimum shipping cost' do
      res = Shipper.get_lowest_cost(@user, @mobile)
      expect(res.service_name).to match 'SHIPPER PREFERENCE'
      expect(res.price_cents).to eq 1000
    end
  end
  context 'shipper has mandated a lower max cost than returned' do
    before { @mobile.update(max_shipping_cost_cents: 100) }
    it 'returns the max shipping cost' do
      res = Shipper.get_lowest_cost(@user, @mobile)
      expect(res.service_name).to match 'SHIPPER PREFERENCE'
      expect(res.price_cents).to eq 100
    end
  end
  context 'shipper mandates a higher lower price than returned' do
    before { @mobile.update(min_shipping_cost_cents: 1000) }
    it 'returns the min shipping cost' do
      res = Shipper.get_lowest_cost(@user, @mobile)
      expect(res.service_name).to match 'SHIPPER PREFERENCE'
      expect(res.price_cents).to eq 1000
    end
  end
  context 'shipper mandates an exact shipping price' do
    before do
      @mobile.update(min_shipping_cost_cents: 1000)
      @mobile.update(max_shipping_cost_cents: 1000)
    end
    it 'returns exact price without consulting APIs' do
      expect(Shipper).not_to receive(:rates_sorted_by_price)
      res = Shipper.get_lowest_cost(@user, @mobile)
      expect(res.service_name).to match 'SHIPPER PREFERENCE'
      expect(res.price_cents).to eq 1000
    end
  end
end
