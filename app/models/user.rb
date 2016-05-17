class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  after_initialize :set_default_role, :if => :new_record?

  has_many :orders
  has_many :completed_orders, -> { paid }, class_name: 'Order'
  has_many :line_items, through: :completed_orders
  has_many :purchased_products, through: :line_items, source: :product

  enum role: [:user, :admin]

  def set_default_role
    self.role ||= :user
  end

  def full_name
    first_name.blank? ? email : first_name
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      user = User.where(email: auth.info.email).first_or_initialize
      unless user.persisted?
        user.password = Devise.friendly_token[0,20]
        user.skip_confirmation!
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
end
