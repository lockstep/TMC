class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  belongs_to :product, class_name: 'Product', foreign_key: 'imageable_id'
  validates_uniqueness_of :primary, scope: [:imageable_id, :imageable_type],
                                    if: :primary
  delegate :url, to: :image

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
      medium: "400x400>"
    }

  validates_attachment_content_type :image,
    content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :image,
    less_than: 3.megabytes

  # needed for Administrate
  # TODO revisit with new versions of Adminstrate with polymorphic support
  def product_id
  end

  def product_id=(id)
    self.product = Product.find(id)
  end
end
