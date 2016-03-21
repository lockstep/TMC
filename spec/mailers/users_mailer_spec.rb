require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  fixtures :users

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  let(:michelle)  { users(:michelle) }
  let(:sender)    { 'noreply@tmc.com' }

  describe 'send .welcome_new_user email' do
    before { UsersMailer.welcome_new_user(michelle.id).deliver_now }

    it 'already sent' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'have correct recipient' do
      expect(ActionMailer::Base.deliveries.first.to).to include(michelle.email)
    end

    it 'have correct sender' do
      expect(ActionMailer::Base.deliveries.first.from).to include(sender)
    end

    it 'have correct subject' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq('Welcome to TMC')
    end
  end

  after do
    ActionMailer::Base.deliveries.clear
  end
end
