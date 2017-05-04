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
end
