class Interest < ActiveRecord::Base
  has_many :personal_interests
  has_many :users, through: :personal_interests

  scope :public_interests, -> { where(public: true).order(:name) }

  def self.update_user_interests(user, interest_names)
    return unless user
    if interest_names.blank?
      return user.interests.destroy_all
    end

    user_interests = []
    interest_names.each do |interest_name|
      public_interest = public_interests.find_by(name: interest_name)
      next unless public_interest
      user_interests.push(public_interest)
    end
    user.update(interests: user_interests)
  end
end
