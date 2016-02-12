require 'rails_helper'

RSpec.describe PresentationsController, type: :controller do
  fixtures :presentations
  describe '#show' do
    let(:memory_game) { presentations(:memory_game) }

    before            { get :show, id: memory_game.id }

    it { expect(response).to render_template('presentations/show') }
  end
end
