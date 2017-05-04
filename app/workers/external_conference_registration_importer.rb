class ExternalConferenceRegistrationImporter
  include Sidekiq::Worker

  def perform(import_id)
    # ExternalConferenceRegistrationImport.find(import_id).import!
  end
end
