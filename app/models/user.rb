class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_initialize :set_default_role, :if => :new_record?

  has_many :orders
  has_many :posts
  has_many :completed_orders, -> { paid }, class_name: 'Order'
  has_many :line_items, through: :completed_orders
  has_many :purchased_products, through: :line_items, source: :product
  has_many :identities
  has_many :personal_interests
  has_many :interests, through: :personal_interests
  has_many :certificate_acquisitions
  has_many :certifications, through: :certificate_acquisitions

  attr_accessor :editing_address, :editing_profile
  validates_presence_of :first_name, :last_name, :address_line_one,
    :address_city, :address_postal_code, :address_country,
    if: :editing_address

  validates_presence_of :first_name, :last_name, :organization_name,
    :position, if: :bambini_pilot_participant?

  validates_presence_of :first_name, :last_name,
    :position, :address_country, if: :opted_in_to_public_directory?

  MAX_BIO_LENGTH = 160
  validates :bio, length: { maximum: MAX_BIO_LENGTH }

  validates_with AttachmentSizeValidator, attributes: :avatar,
    content_type: { content_type: ['image/jpeg', 'image/png'] },
    less_than: 1.megabyte

  enum role: [:user, :admin]

  delegate :url, to: :avatar, prefix: true

  POSITIONS = [
    'Montessori Guide', 'Head of School', 'Principal',
    'Administrator', 'Assistant', 'Trainer', 'Consultant',
    'Material Maker', 'Day Care Provider',
    'Parent', 'Other'
  ]

  has_attached_file :avatar,
    url: ':s3_domain_url',
    path: 'avatars/:id/:basename.:hash.:extension',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    hash_secret: "JUST4URLUNIQUENESS",
    s3_protocol: "https",
    styles: {
      thumb: "100x100#", small: "200x200#", medium: "400x400#"
    },
    default_url: "#{ENV['HOST']}/images/montessori_avatar.jpg"

  validates_attachment_content_type :avatar,
    content_type: /\Aimage\/.*\Z/

  scope :opted_in_to_public_directory, -> {
    where(opted_in_to_public_directory: true)
  }

  def profile_complete?
    required_fields = [
      :first_name, :last_name, :bio, :address_city, :address_country,
      :avatar_file_name
    ]
    required_fields.all? { |attr| send(attr).present? }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address_country
    return if address_country.blank?
    country = ISO3166::Country[address_country]
    country.translations[I18n.locale.to_s] || country.name
  end

  def public_location(full_country = false)
    location_string = address_country || ''
    if address_country && full_country
      location_string = full_address_country
    end
    if address_state.present?
      location_string = address_country ?
        "#{address_state}, #{location_string}" : address_state
    end
    if address_city.present?
      location_string = "#{address_city}, #{location_string}"
    end
    location_string
  end

  def set_default_role
    self.role ||= :user
  end

  def address_complete?
    [
      :address_line_one, :address_city, :address_postal_code,
      :address_country
    ].all? { |attr| send(attr).present? }
  end

  def active_shipping_location
    ActiveShipping::Location.new(
      address1: address_line_one, address2: address_line_two,
      country: address_country, state: address_state, city: address_city,
      zip: address_postal_code
    )
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    return unless auth.info.email

    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      user = User.where(email: auth.info.email).first_or_initialize
      unless user.persisted?

        user.password = Devise.friendly_token[0,20]
        user.save!
        user.set_up_registering_user!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def remember_me
    true
  end

  def set_up_registering_user!
    send_welcome_email
    subscribe_to_mailchimp
  end

  private

  def password_required?
    if respond_to?(:reset_password_token)
      return true if reset_password_token.present?
    end
    return true if new_record?
    password.present? || password_confirmation.present?
  end

  def send_welcome_email
    WelcomeNewUserWorker.perform_in(1.second, self.id)
  end

  def subscribe_to_mailchimp
    MailchimpSubscriberWorker.perform_async(email)
  end
end
