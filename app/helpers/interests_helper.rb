module InterestsHelper
  def user_interests(user)
    interest_names = user.interests.pluck(:name)
    return 'N/A' unless interest_names.present?
    interest_names.sort.join(', ')
  end

  def have_interest?(user, interest_name)
    user.interests.pluck(:name).include?(interest_name)
  end
end
