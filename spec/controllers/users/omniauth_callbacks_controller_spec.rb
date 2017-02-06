describe Users::OmniauthCallbacksController do
  fixtures :users
  fixtures :products

  include_context 'before_after_mailer'

  before do
    Product.reindex
    allow(MailchimpSubscriberWorker).to receive(:perform_async)
  end

  describe 'user does not share their email' do
    before do
      stub_env_for_omniauth(nil)
      get :facebook
    end

    it 'does not create a user Identity' do
      expect(Identity.count).to eq 0
    end

    it 'redirects back to sign up form with a message' do
      expect(response).to redirect_to new_user_registration_path
      expect(flash[:alert]).to match 'using the form below'
    end
  end

  describe "new user" do
    before do
      stub_env_for_omniauth('user@email.com')
      get :facebook
      @user = User.find_by(email: "user@email.com")
    end

    it 'creates the user'do
      expect(@user).not_to be_nil
    end

    it 'creates a user Identity' do
      identity = @user.identities.first
      expect(identity).not_to be_nil
      expect(identity.provider).to eq 'facebook'
      expect(identity.uid).to eq '12345678'
    end

    it 'signs in the user' do
      expect(subject.current_user).to eq @user
    end

    it 'sends out a welcome email' do
      expect(ActionMailer::Base.deliveries.count).to eq 1
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq 'Welcome to The Montessori Company'
    end

    it 'subscribes the user to Mailchimp' do
      expect(MailchimpSubscriberWorker).to have_received(:perform_async)
        .with(@user.email)
    end
  end

  describe 'an existing user' do
    before do
      stub_env_for_omniauth('paul@tmc.com')
      @user = users(:paul)
    end
    context 'identity does not exist' do
      before { get :facebook }
      it 'creates a user Identity' do
        identity = @user.identities.first
        expect(identity).not_to be_nil
        expect(identity.provider).to eq 'facebook'
        expect(identity.uid).to eq '12345678'
      end

      it 'signs in the user' do
        expect(subject.current_user).to eq @user
      end

      it 'does not send out welcome email' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
    context 'identity exists' do
      before do
        Identity.create(user: @user, provider: 'facebook', uid: '12345678')
        get :facebook
      end

      it 'does not create a new Identity' do
        expect(@user.identities.count).to eq 1
      end

      it 'signs in the user' do
        expect(subject.current_user).to eq @user
      end

      it 'does not send out welcome email' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
  end
end

def stub_env_for_omniauth(email)
  request.env["devise.mapping"] = Devise.mappings[:user]
  env = { "omniauth.auth" =>
    OmniAuth::AuthHash.new({
      provider: "facebook",
      uid: "12345678",
      info: OmniAuth::AuthHash::InfoHash.new(email: email)
    })
  }
  allow(@controller).to receive(:env).and_return(env)
end
