class ExternalConferenceRegistrationImporter
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(import_id)
    ExternalConferenceRegistrationImport.find(import_id).import!
  end
end
