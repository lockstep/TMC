describe ProductsController, type: :controller do
  fixtures :products

  let(:number_cards)  { products(:number_cards) }

  describe '#show' do
    before do
      get :show, id: number_cards.id
    end

    it { expect(response).to render_template('products/show') }
  end
end
