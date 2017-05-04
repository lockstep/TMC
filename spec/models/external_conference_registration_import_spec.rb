describe ExternalConferenceRegistrationImport do
  describe '#import!' do
    before do
      @conference = create(:conference)
      @import = create(:external_conference_registration_import,
                       conference: @conference)
      @file_path =
        'spec/fixtures/external_conference_registration_imports/example.csv'
      double_file = double('import_file', expiring_url: @file_path)
      allow(@import).to receive(:import_file).and_return double_file
    end
    it 'creates the records' do
      @import.import!
      expect(
        ExternalConferenceRegistration.where(conference: @conference).count
      ).to eq 10
    end
  end
end
