describe 'Sign out', :devise do
  fixtures :users

  let(:michelle)    { users(:michelle) }
  let(:referrer)    { '/pages/about' }

  before { signin(michelle.email, 'qawsedrf') }

  it 'user can sign out' do
    click_on('Logout')
    expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
  end

  it 'redirect user to referrer page' do
    visit referrer
    click_on('Logout')

    expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
    expect(page).to have_current_path root_path
  end
end
