describe PagesController, type: :request do
  context 'preaction present' do
    before { @user = create(:user) }
    it 'performs the preaction' do
      expect(@user).to be_private_messages_enabled
      get '/', preaction: 'disable_private_messages', user_id: @user.id,
        email_access_token: @user.email_access_token
      expect(@user).not_to be_private_messages_enabled
    end
  end
end

describe PagesController, type: :controller do
  describe '#show' do
    PagesController::PAGES.each do |page|
      next if page.match 'bambini'
      context "Access to #{page} page" do
        subject { get :show, page: page }
        it { is_expected.to render_template("pages/#{page}")}
      end
    end
    context 'Access non-existing page' do
      subject { get :show, page: 'not-existed' }
      it { is_expected.to redirect_to(root_path) }
    end

    context 'Error pages' do
      ['403', '404'].each do |error|
        subject { get :show, page: error }

        it { is_expected.to redirect_to(root_path) }
      end
    end

    describe 'free materials page' do
      it 'stores the location for user' do
        get :show, page: 'free-montessori-materials-printables'
        expect(session["user_return_to"])
          .to eq '/pages/free-montessori-materials-printables'
      end
    end
  end
end
