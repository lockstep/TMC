module Admin
  class ExternalConferenceRegistrationImportsController < Admin::ApplicationController

    def new
    end

    def create
      external_conference_registration_import =
        ExternalConferenceRegistrationImport.create!(import_params)
      ExternalConferenceRegistrationImporter.perform_in(
        1.second, external_conference_registration_import.id
      )
      redirect_to :back, notice: 'Success'
    end

    private

    def import_params
      params.require(:external_conference_registration_import).permit(
        :conference_id, :import_file
      )
    end

  end
end
