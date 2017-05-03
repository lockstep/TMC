feature 'Admin imports breakout sessions' do
  before do
    @admin = create(:admin)
    signin(@admin.email)
    @conference = create(:conference)
    @standard_import_file_path =
      'spec/fixtures/breakout_session_imports/standard.csv'
  end
  context 'no organizers exist' do
    scenario 'no breakout sessions created' do
      visit new_admin_breakout_session_import_path
      complete_import
      expect(BreakoutSession.count).to eq 0
    end
  end
  context 'organizer exists' do
    before do
      @organizer = create(
        :user, email: 'ktaylor@stmarys-ca.edu',
        opted_in_to_public_directory: true
      )
    end
    scenario 'breakout session is created' do
      visit new_admin_breakout_session_import_path
      complete_import
      expect(page).to have_content 'my title'
      expect(page).to have_content '14:00 - 15:30'
      expect(page).to have_content 'Friday Jul 28'
      expect(page).to have_content 'Meeting Hall'
    end
  end

  def complete_import
    select @conference.name, from: 'admin_breakout_session_import_conference_id'
    attach_file 'admin_breakout_session_import_import_file', @standard_import_file_path
    click_button 'Import'
  end
end
