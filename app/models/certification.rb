class Certification < ActiveRecord::Base
  has_many :certificate_acquisitions
  has_many :users, through: :certificate_acquisitions

  validates_uniqueness_of :name, if: :public?

  scope :public_certifications, -> { where(public: true).order(:name) }

  def self.manage_user_certifications(user, certification_names)
    return unless user
    return delete_user_unused_certifications(user) if certification_names.blank?

    new_user_certifications = []
    certification_names.each do |certification_name|
      user_certification = user.certifications.find_by(name: certification_name)
      next new_user_certifications << user_certification if user_certification

      public_certification = public_certifications.find_by(name: certification_name)
      if public_certification
        new_user_certifications << public_certification
        user.certifications << public_certification
        user.save
        next
      end

      new_user_certifications << user.certifications.create(name: certification_name)
    end

    delete_user_unused_certifications(user, new_user_certifications)
  end

  private

  def self.delete_user_unused_certifications(user, new_certifications = [])
    return unless user
    user_private_certifications = user.certifications
      .reject { |certification| certification.public }
    unused_certifications = user_private_certifications - new_certifications
    unused_certifications.map(&:destroy)
  end

end

