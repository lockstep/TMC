require 'rails_helper'

RSpec.describe PresentationsController, type: :controller do
  fixtures :presentations

  describe '#index' do
    before { get :index }

    it {expect(response).to render_template('presentations/index')}
  end

  describe '#show' do
    let(:memory_game) { presentations(:memory_game) }

    before            { get :show, id: memory_game.id }

    it { expect(response).to render_template('presentations/show') }
  end

end
