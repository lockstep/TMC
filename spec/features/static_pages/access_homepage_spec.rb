describe 'Visitors access to Homepage', type: :feature do
  let(:application_name)  { 'TMC' }

  before { visit root_path }

  it 'should display application\'s name' do
    expect(page).to have_content(application_name)
  end
end
