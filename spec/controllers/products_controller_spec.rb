describe ProductsController, type: :controller do
  fixtures :products
  fixtures :orders
  fixtures :downloadables

  before(:all) do
    Product.reindex
  end

  let(:number_cards)  { products(:number_cards) }

  describe '#index' do
    before { get :index }
    it {expect(response).to render_template('products/index')}

    it_behaves_like 'it sets current order instance'

    context 'invalid sort param' do
      it 'falls back to the default setting' do
        get :index, sort: 'made_up'
        expect(response.status).to eq 200
      end
    end
    context 'invalid topic id' do
      it 'ignores the param' do
        get :index, topic_ids: 'made_up'
        expect(response.status).to eq 200
      end
    end
  end

  describe '#show' do
    it_behaves_like 'it sets current order instance'
    it 'renders the correct template' do
      get :show, id: number_cards.id
      expect(response).to render_template('products/show')
    end
  end
end
