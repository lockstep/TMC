class BreakoutSessionSupplement < ActiveRecord::Base
  belongs_to :breakout_session

  has_attached_file :document,
    url: ':s3_domain_url',
    path: 'breakout_session_supplements/:id/:basename.:extension',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    hash_secret: "JUST4URLUNIQUENESSes",
    s3_protocol: "https"

  validates_with AttachmentSizeValidator,
    attributes: :document, less_than: 5.megabytes

  validates_with AttachmentContentTypeValidator,
    attributes: :document,
    content_type: [
      "application/pdf",
      "application/msword",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "application/vnd.ms-excel",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.ms-powerpoint",
      "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      "text/plain",
      "text/csv",
      "text/comma-separated-values"
    ]
end
