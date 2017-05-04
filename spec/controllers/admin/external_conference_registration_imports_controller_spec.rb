describe Admin::ExternalConferenceRegistrationImportsController, type: :controller do
  before do
    @user = create(:admin)
    @conference = create(:conference)
    sign_in @user
    request.env["HTTP_REFERER"] = root_path
  end

  describe '#create' do
    context 'user is not the organizer' do
      it 'queues the worker' do
        allow(ExternalConferenceRegistrationImporter)
          .to receive(:perform_in).and_return true
        post :create, import_params
        new_import = ExternalConferenceRegistrationImport.first
        expect(ExternalConferenceRegistrationImporter)
          .to have_received(:perform_in).with(1.second, new_import.id)
      end
    end
  end

  def import_params
    {
      external_conference_registration_import: {
        conference_id: @conference.id
      }
    }
  end
end
