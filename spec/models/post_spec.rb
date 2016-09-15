describe Post, type: :model do
  fixtures :posts
  fixtures :users

  describe '#user' do
    before { @post = posts(:hello_tmc) }
    it 'returns the author of the post' do
      expect(@post.user.full_name).to eq 'Michelle TMC'
    end
  end

  describe '#stripped_body' do
    before { @post = posts(:hello_tmc) }
    it 'returns the post body without unwanted tags and their content' do
      expect(@post.stripped_body).to include 'educational approach'
      expect(@post.stripped_body).not_to include '<div>'
      expect(@post.stripped_body).not_to include '<figcaption>'
      expect(@post.stripped_body).not_to include 'strip this'
    end
  end

  describe 'slug' do
    before { @post = posts(:hello_tmc) }
    it 'changes when title changes but keeps the history' do
      @post.update(title: 'Pizza')
      expect(@post.reload.slug).to eq 'pizza'
      @post.update(title: 'Donut')
      expect(@post.reload.slug).to eq 'donut'
      expect(Post.friendly.find('pizza')).to eq @post
      expect(Post.friendly.find('donut')).to eq @post
    end
  end
end
