require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  fixtures :materials

  let(:number_cards)  { materials(:number_cards) }

  describe '#show' do
    before            { get :show, id: number_cards.id }

    it { expect(response).to render_template('materials/show') }
  end

end
