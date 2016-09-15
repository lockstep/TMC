describe PostsController, type: :controller do
  fixtures :posts
  fixtures :users

  before do
    @post = posts(:hello_tmc)
  end

  describe '#index' do
    subject { get :index }

    it { is_expected.to render_template('posts/index') }
  end

  describe '#show' do
    subject { get :show, id: @post.slug }

    it { is_expected.to render_template('posts/show') }

    context 'changing slug' do
      before do
        @post.update(title: 'pizza')
        @post.update(title: 'donut')
      end
      it 'returns 200 for the current slug' do
        get :show, id: 'donut'
        expect(response.status).to eq 200
      end
      it 'returns a 301 for older slugs' do
        get :show, id: 'pizza'
        expect(response.status).to eq 301
        expect(response).to redirect_to post_path(@post)
      end
    end
  end
end
