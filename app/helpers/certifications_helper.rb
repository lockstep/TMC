module CertificationsHelper
  def user_certifications(user)
    certification_names = user.certifications.pluck(:name)
    return 'N/A' unless certification_names.present?
    certification_names.sort.join(', ')
  end

  def has_certification?(user, certification_name)
    user.certifications.pluck(:name).include?(certification_name)
  end
end
