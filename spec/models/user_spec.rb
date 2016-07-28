describe User, type: :model do

  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:michelle)              { users(:michelle) }
  let(:purchased_product)     { products(:animal_cards) }

  describe '#email' do
    it { expect(michelle.email).to eq 'mich@tmc.com' }
  end

  describe '#purchased_products' do
    it 'returns an array of purchased products' do
      expect(michelle.purchased_products.size).to eq 3
      expect(michelle.purchased_products.first).to eq purchased_product
    end
  end

  describe '#role' do
    it 'returns role as a string' do
      expect(michelle.role).to be_kind_of(String)
    end
  end

  describe '#set_default_role' do
    it 'role=user when initialize' do
      expect(User.new.role).to eq('user')
    end
  end
end
