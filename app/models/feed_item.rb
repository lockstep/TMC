class FeedItem < ActiveRecord::Base
  belongs_to :feedable, polymorphic: true
  belongs_to :author, class_name: 'User'

  validates_presence_of :message, if: "raw_image_s3_key.blank?", on: :create

  delegate :first_name, :full_name, :avatar, :position, :organization_name,
    to: :author, allow_nil: true,
    prefix: true

  has_attached_file :image,
    url: ':s3_domain_url',
    path: 'images/:id/:basename.:hash.:extension',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    hash_secret: "JUST4URLUNIQUENESS",
    s3_protocol: "https",
    styles: {
      thumb: "100x100#",
      medium: "500>",
      large: "750>"
    }

  validates_attachment_content_type :image,
    content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :image,
    less_than: 4.megabytes
end
