describe UsersMailer, type: :mailer do
  include_context 'before_after_mailer'

  fixtures :users
  fixtures :products
  fixtures :line_items
  fixtures :orders

  let(:michelle)  { users(:michelle) }

  before { Product.reindex }

  describe '.welcome_new_user' do
    before { UsersMailer.welcome_new_user(michelle.id).deliver_now }

    it_behaves_like "sending_email" do
      let(:recipients) { [ michelle.email] }
      let(:subject)    { 'Welcome to The Montessori Company' }
    end

    it 'renders best-sellers correctly' do
      flamingo = products(:flamingo)
      email = ActionMailer::Base.deliveries.last.encoded
      expect(email).to match flamingo.name
      expect(email).to match product_url(flamingo)
    end
  end
end
