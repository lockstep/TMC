require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  include_context 'before_after_mailer'
  fixtures :users

  let(:michelle)  { users(:michelle) }

  describe '.welcome_new_user' do
    before { UsersMailer.welcome_new_user(michelle.id).deliver_now }

    it_behaves_like "sending_email" do
      let(:sender)     { ['hello@themontessoricompany.com'] }
      let(:recipients) { [ michelle.email] }
      let(:subject)    { 'Welcome to The Montessori Company' }
    end
  end
end
