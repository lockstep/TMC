describe 'Blog', type: :feature do
  fixtures :posts

  before do
    @post = posts(:hello_tmc)
  end

  it 'generates post preview from post body, strips tags' do
    visit posts_path
    expect(page).to have_content @post.title
    expect(page).not_to have_content '<div>'
    first(:link, 'continue').click
    expect(page).to have_content @post.title
  end
end
