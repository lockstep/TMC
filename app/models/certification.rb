class Certification < ActiveRecord::Base
  has_many :certificate_acquisitions
  has_many :users, through: :certificate_acquisitions

  scope :public_certifications, -> { where(public: true).order(:name) }

  def self.update_user_certifications(user, certification_names)
    return unless user
    if certification_names.blank?
      return user.certifications.destroy_all
    end

    user_certifications = []
    certification_names.each do |certification_name|
      public_certification = public_certifications
        .find_by(name: certification_name)
      next unless public_certification
      user_certifications.push(public_certification)
    end
    user.update(certifications: user_certifications)
  end
end

