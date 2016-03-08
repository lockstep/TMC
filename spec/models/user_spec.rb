describe User, type: :model do
  fixtures :users

  let(:michelle)  { users(:michelle) }

  describe '.email' do
    it { expect(michelle.email).to eq 'mich@tmc.com' }
  end
end
