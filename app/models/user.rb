class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_initialize :set_default_role, :if => :new_record?
  after_commit :send_welcome_email, :subscribe_to_mailchimp, on: :create

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
  validates_presence_of :first_name, :last_name, :address_line_one,
    :address_city, :address_postal_code, :address_country,
    if: :editing_profile

  validates_presence_of :first_name, :last_name, :school_name,
    :position, if: :bambini_pilot_participant?

  enum role: [:user, :admin]

  delegate :url, to: :avatar, prefix: true

  POSITIONS = [
    'Montessori Guide', 'Montessori Head of School',
    'Montessori Administrator', 'Teacher',
    'Principal', 'School Administrator', 'Day Care Provider',
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
      medium: "400x400>"
    }

  validates_attachment_content_type :avatar,
    content_type: /\Aimage\/.*\Z/

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

  def public_location
    if address_state.blank?
      "#{address_city}, #{address_country}"
    else
      "#{address_city}, #{address_state}, #{address_country}"
    end
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

  private

  def password_required?
    if respond_to?(:reset_password_token)
      return true if reset_password_token.present?
    end
    return true if new_record?
    password.present? || password_confirmation.present?
  end

  def send_welcome_email
    WelcomeNewUserWorker.perform_async(self.id)
  end

  def subscribe_to_mailchimp
    MailchimpSubscriberWorker.perform_async(self.id)
  end
end
