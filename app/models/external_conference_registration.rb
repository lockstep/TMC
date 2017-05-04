class ExternalConferenceRegistration < ActiveRecord::Base
  belongs_to :conference
  validates_presence_of :email

  def self.find_or_create_from_import_row(attributes)
    registration = find_or_create_by(
      email: attributes[:email], conference_id: attributes[:conference_id]
    )
    registration.update(attributes)
  end
end
