class Downloadable < ActiveRecord::Base
  belongs_to :product

  has_attached_file :file,
    url: ':s3_domain_url',
    path: 'downloadables/:id/:basename.:hash.:extension',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    hash_secret: "JUST4URLUNIQUENESS",
    s3_protocol: "https",
    styles: {
      thumb: ["100x100#", :jpg],
      medium: ["400x400>", :jpg]
    }

    validates_with AttachmentContentTypeValidator, attributes: :file,
      content_type: /pdf/
end
