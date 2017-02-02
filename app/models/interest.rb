class Interest < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [ :slugged, :finders ]
  has_many :personal_interests
  has_many :users, through: :personal_interests

  validates_uniqueness_of :name, if: :public?

  scope :public_interests, -> { where(public: true).order(:name) }

  def self.manage_user_interests(user, interest_names)
    return unless user
    return delete_user_unused_interests(user) if interest_names.blank?

    new_user_interests = []
    interest_names.each do |interest_name|
      user_interest = user.interests.find_by(name: interest_name)
      next new_user_interests << user_interest if user_interest

      public_interest = public_interests.find_by(name: interest_name)
      if public_interest
        new_user_interests << public_interest
        user.interests << public_interest
        user.save
        next
      end

      new_user_interests << user.interests.create(name: interest_name)
    end

    delete_user_unused_interests(user, new_user_interests)
  end

  private

  def self.delete_user_unused_interests(user, new_interests = [])
    return unless user
    user_private_interests = user.interests.reject { |interest| interest.public }
    unused_interests = user_private_interests - new_interests
    unused_interests.map(&:destroy)
  end

end
