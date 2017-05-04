feature 'Admin imports external conference registrations' do
  before do
    @admin = create(:admin)
    signin(@admin.email)
    @conference = create(:conference)
    @standard_import_file_path =
      'spec/fixtures/external_conference_registration_imports/example.csv'
  end

  scenario 'executes and shows success' do
    visit new_admin_external_conference_registration_import_path
    complete_import
    expect(page).to have_content 'Success'
  end

  def complete_import
    select @conference.name,
      from: 'external_conference_registration_import_conference_id'
    attach_file 'external_conference_registration_import_import_file',
      @standard_import_file_path
    click_button 'Import'
  end
end
