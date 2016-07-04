describe Promotion, type: :model do
  fixtures :promotions

  describe 'hooks' do
    it 'downcases code before save' do
      new_promotion = Promotion.new(code: 'SPRINGPROMO', percent: 10)
      new_promotion.save!
      expect(new_promotion.code).to eq 'springpromo'
    end
  end

  describe 'validations' do
    context 'code' do
      it 'checks for code uniqueness' do
        new_promotion = Promotion.new(code: 'WELCOME', percent: 10)
        expect(new_promotion).not_to be_valid
      end
      it 'uniqueness is case insensitive' do
        new_promotion = Promotion.new(code: 'Welcome', percent: 10)
        expect(new_promotion).not_to be_valid
      end
      it 'invalidates a missing code' do
        new_promotion = Promotion.new(code: nil, percent: 10)
        expect(new_promotion).not_to be_valid
      end
      it 'invalidates an empty code' do
        new_promotion = Promotion.new(code: "", percent: 10)
        expect(new_promotion).not_to be_valid
      end
      it 'allows unique codes' do
        new_promotion = Promotion.new(code: 'WELCOME!!!', percent: 10)
        expect(new_promotion).to be_valid
      end
    end
    context 'percent' do
      it 'invalidates percent as string' do
        new_promotion = Promotion.new(code: 'abc', percent: 'WELCOME')
        expect(new_promotion).not_to be_valid
      end
      it 'invalidates negative percent' do
        new_promotion = Promotion.new(code: 'abc', percent: -10)
        expect(new_promotion).not_to be_valid
      end
      it 'invalidates percent > 100' do
        new_promotion = Promotion.new(code: 'abc', percent: 101)
        expect(new_promotion).not_to be_valid
      end
      it 'invalidates nil percent' do
        new_promotion = Promotion.new(code: 'abc', percent: nil)
        expect(new_promotion).not_to be_valid
      end
      it 'allows valid percent' do
        new_promotion = Promotion.new(code: 'abc', percent: 10)
        expect(new_promotion).to be_valid
      end
    end
  end

  describe '#active? #inactive?' do
    context 'present starts_at and expires_at' do
      it 'returns true' do
        new_promotion = Promotion.create(code: 'abc', percent: 10,
                                         starts_at: 1.day.ago,
                                         expires_at: 3.days.from_now)
        expect(new_promotion.active?).to be true
        expect(new_promotion.inactive?).to be false
      end
    end
    context 'missing starts_at' do
      it 'returns true' do
        new_promotion = Promotion.create(code: 'abc', percent: 10,
                                         expires_at: 3.days.from_now)
        expect(new_promotion.active?).to be true
        expect(new_promotion.inactive?).to be false
      end
    end
    context 'missing expires_at' do
      it 'returns true' do
        new_promotion = Promotion.create(code: 'abc', percent: 10,
                                         starts_at: 1.day.ago)
        expect(new_promotion.active?).to be true
        expect(new_promotion.inactive?).to be false
      end
    end
    context 'inactive' do
      it 'returns false' do
        new_promotion = Promotion.create(code: 'abc', percent: 10,
                                         expires_at: 3.days.ago)
        expect(new_promotion.active?).to be false
        expect(new_promotion.inactive?).to be true
      end
    end
  end
end
