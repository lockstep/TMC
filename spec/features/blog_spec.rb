describe 'Blog', type: :feature do
  fixtures :posts
  fixtures :users

  before do
    @has_author = posts(:hello_tmc)
    @no_author = posts(:announcement)
  end

  describe 'blog index page' do
    it 'generates post preview from post body, strips tags' do
      visit posts_path
      expect(page).to have_content @no_author.title
      expect(page).not_to have_content '<div>'
      expect(page).not_to have_content 'strip this'
    end

    describe 'authors' do
      context 'blog post has author' do
        it 'shows author section' do
          visit posts_path
          within "#blog-post-#{@has_author.id}" do
            expect(page).to have_content 'by Michelle TMC'
            expect(page).to have_css("img[src*='images/montessori_avatar.jpg']")
          end
        end
      end
      context 'no author' do
        it 'does not show author section' do
          visit posts_path
          within "#blog-post-#{@no_author.id}" do
            expect(page).not_to have_css(
              "img[src*='avatars/medium/missing.png']"
            )
          end
        end
      end
    end

    describe 'cover images' do
      context 'blog post has cover' do
        before do
          allow_any_instance_of(Post).to receive(:cover_url)
            .and_return('my_cover.png')
        end
        it 'shows the cover image' do
          visit posts_path
          expect(page).to have_content @no_author.title
          expect(page).to have_css("img[src*='my_cover.png']")
        end
      end
      context 'blog post has no cover' do
        it 'shows the default image' do
          visit posts_path
          expect(page).to have_content @no_author.title
          expect(page).to have_css(
           "img[src*='covers/medium/missing.png']"
          )
        end
      end
    end
  end

  describe 'blog show page' do
    context 'no author' do
      it 'renders blog post without author section' do
        visit post_path @no_author
        expect(page).to have_content @no_author.title
      end
    end

    context 'blog post has an author' do
      it 'generates post preview from post body, strips tags' do
        visit post_path @has_author
        expect(page).to have_content @has_author.title
        expect(page).to have_content @has_author.user.full_name
        expect(page).to have_content @has_author.user.bio
        expect(page).to have_content 'Living Montessori'
      end
    end
  end
end
