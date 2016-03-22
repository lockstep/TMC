require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  include_context 'before_after_mailer'
  fixtures :users

  let(:new_guy)    { users(:new_guy) }

  describe '#show' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :show, confirmation_token: new_guy.confirmation_token
    end

    context 'welcome_email was sent' do
      it 'email was delivered' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end
end
