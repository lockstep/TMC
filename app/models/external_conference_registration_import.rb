require 'csv'

class ExternalConferenceRegistrationImport < ActiveRecord::Base
  belongs_to :conference

  has_attached_file :import_file,
    url: ':s3_domain_url',
    path: 'external_conference_registration_imports/:id/:basename.:hash.:extension',
    storage: :s3,
    s3_permissions: :private,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    hash_secret: "JUS4URLUNIQUENESSes",
    s3_protocol: "https"

    validates_with AttachmentContentTypeValidator,
      attributes: :import_file,
      content_type: [
        "text/csv",
        "text/comma-separated-values"
      ]

    validates_with AttachmentSizeValidator,
      attributes: :import_file, less_than: 3.megabytes

  def import!
    CSV.parse(
      open(import_file.expiring_url(10.seconds), "r:iso-8859-1"),
      :headers => true
    ) do |row|
      ExternalConferenceRegistration.find_or_create_from_import_row(
        row_attributes(row)
      )
    end
  end

  private

  def row_attributes(row)
    names = row['Name'].split(',')
    first_name = names.size > 1 ? names[1].strip : nil
    last_name = names.size > 1 ? names[0].strip : nil
    registered_on = Date.strptime(row['Regist Date'].strip, '%m/%d/%Y')
    {
      first_name: first_name,
      last_name: last_name,
      external_id: row['Reg. No.'],
      country_code: row['Country'],
      email: row['email']&.strip,
      company: row['Company'],
      registered_on: registered_on,
      conference_id: conference.id
    }
  end

end
