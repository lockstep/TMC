describe User, type: :model do
  fixtures :users
  fixtures :orders

  let(:michelle)              { users(:michelle) }
  let(:cards_order)           { orders(:cards_order) }
  let(:cards_order_completed) { orders(:cards_order_completed) }

  describe '#email' do
    it { expect(michelle.email).to eq 'mich@tmc.com' }
  end

  describe '#orders' do
    it 'return orders correctly' do
      expect(michelle.orders.count).to eq(2)
    end
  end

  describe '#role' do
    it 'return role as a string' do
      expect(michelle.role).to be_kind_of(String)
    end
  end

  describe '#set_default_role' do
    it 'role=user when initialize' do
      expect(User.new.role).to eq('user')
    end
  end
end
