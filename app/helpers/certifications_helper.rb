module CertificationsHelper
  def format_user_certifications(user)
    certification_names = user.certifications.pluck(:name)
    return '' unless certification_names.present?
    certification_names.sort.join(', ')
  end

  def has_certification?(user, certification_name)
    user.certifications.pluck(:name).include?(certification_name)
  end

  def certifications_available_to(user)
    Certification.public_certifications.concat(user.certifications)
      .uniq.sort_by(&:name)
  end
end
