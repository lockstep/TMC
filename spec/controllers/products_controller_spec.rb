describe ProductsController, type: :controller do
  fixtures :products
  fixtures :orders
  fixtures :users

  let(:number_cards)  { products(:number_cards) }
  let(:user)          { users(:michelle) }

  before { Product.reindex }

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

    describe 'search tracking' do
      context 'search query is present' do
        it 'tracks the search' do
          get :index, q: 'monkey'
          expect(Searchjoy::Search.count).to eq 1
          search = Searchjoy::Search.last
          expect(search.query).to eq 'monkey'
          expect(search.search_type).to eq 'Product'
        end

        it 'does not track if the user is paginating' do
          get :index, q: 'monkey', page: 4
          expect(Searchjoy::Search.count).to eq 0
        end

        context 'the user is logged in' do
          before do
            sign_in user
          end
          it 'tracks the search with user ID' do
            get :index, q: 'monkey'
            expect(Searchjoy::Search.count).to eq 1
            search = Searchjoy::Search.last
            expect(search.query).to eq 'monkey'
            expect(search.search_type).to eq 'Product'
            expect(search.user_id).to eq user.id
          end
        end
      end

      context 'index request without any search query' do
        it 'does not track' do
          get :index
          expect(Searchjoy::Search.count).to eq 0
        end
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
