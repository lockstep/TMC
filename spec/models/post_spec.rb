describe Post, type: :model do
  describe '#stripped_body' do
    fixtures :posts

    before do
      @post = posts(:hello_tmc)
    end

    it 'returns the post body without unwanted tags and their content' do
      expect(@post.stripped_body).to include 'educational approach'
      expect(@post.stripped_body).not_to include '<div>'
      expect(@post.stripped_body).not_to include '<figcaption>'
      expect(@post.stripped_body).not_to include 'strip this'
    end
  end
end
