describe PresentationsController, type: :controller do
  fixtures :presentations
  fixtures :topics

  describe '#index' do
    before { get :index }

    it {expect(response).to render_template('presentations/index')}
  end

  describe '#show' do
    let(:quiz_game) { presentations(:quiz_game) }

    before            { get :show, id: quiz_game.id }

    it { expect(response).to render_template('presentations/show') }
  end

end
