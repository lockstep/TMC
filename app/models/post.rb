class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  belongs_to :user

  delegate :url, to: :cover, prefix: true

  has_attached_file :cover,
    url: ':s3_domain_url',
    path: 'blog/covers/:id/:basename.:hash.:extension',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    hash_secret: "JUST4URLUNIQUENESS",
    s3_protocol: "https",
    styles: {
      medium: "600x300>"
    }

  validates_attachment_content_type :cover,
    content_type: /\Aimage\/.*\Z/

  def slug_candidates
    [ :title ]
  end

  def stripped_body
    doc = Nokogiri::XML(body)
    doc.xpath("//figcaption").remove
    helpers.strip_tags(doc.text)
  end

  private

  def helpers
    ActionController::Base.helpers
  end
end
