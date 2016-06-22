describe ProductsController, type: :controller do
  fixtures :products

  before(:all) do
    Product.reindex
  end

  let(:number_cards)  { products(:number_cards) }

  describe '#index' do
    before { get :index }
    it {expect(response).to render_template('products/index')}
  end

  describe '#show' do
    it 'renders the correct template' do
      get :show, id: number_cards.id
      expect(response).to render_template('products/show')
    end
  end
end
