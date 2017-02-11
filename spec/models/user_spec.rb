describe User, type: :model do

  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:michelle)              { users(:michelle) }
  let(:purchased_product)     { products(:animal_cards) }

  describe 'callbacks' do
    it 'subscribes the user to Mailchimp after create' do
      allow(MailchimpSubscriberWorker).to receive(:perform_async)
      user = User.create(email: 'erik@tmc.com', password: 'mypassword',
                        password_confirmation: 'mypassword')
      expect(MailchimpSubscriberWorker).to have_received(:perform_async)
        .with(user.email)
    end
  end

  describe '#email' do
    it { expect(michelle.email).to eq 'mich@tmc.com' }
  end

  describe '#public_location' do
    before do
      @user = build(
        :user, address_city: 'C', address_state: 'S', address_country: 'CO'
      )
    end
    context 'user as all fields' do
      it 'shows full address' do
        expect(@user.public_location).to eq 'C, S, CO'
      end
    end
    context 'user has only city/state' do
      before { @user.update(address_country: nil) }
      it 'returns city and state' do
        expect(@user.public_location).to eq 'C, S'
      end
    end
    context 'user has only country' do
      before { @user = build(:user, address_country: 'CO') }
      it 'shows only country' do
        expect(@user.public_location).to eq 'CO'
      end
    end
    context 'user has only state/country' do
      before { @user.update(address_city: nil) }
      it 'shows only country' do
        expect(@user.public_location).to eq 'S, CO'
      end
    end
    context 'user has only city/country' do
      before { @user.update(address_state: nil) }
      it 'shows only country' do
        expect(@user.public_location).to eq 'C, CO'
      end
    end
  end

  describe '#full_name' do
    it { expect(michelle.full_name).to eq 'Michelle TMC' }
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
