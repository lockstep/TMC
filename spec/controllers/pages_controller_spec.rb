describe PagesController, type: :controller do
  describe '#show' do
    PagesController::PAGES.each do |page|
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
  end
end
