module InterestsHelper
  def format_user_interests(user)
    interest_names = user.interests.pluck(:name)
    return '' unless interest_names.present?
    interest_names.sort.join(', ')
  end

  def user_interests_with_links(user)
    user.interests.order(name: :asc).map do |interest|
      if interest.public?
        link_to(interest.name, interest_path(interest))
      else
        interest.name
      end
    end.join(', ').html_safe
  end

  def has_interest?(user, interest_name)
    user.interests.pluck(:name).include?(interest_name)
  end

  def interests_available_to(user)
    Interest.public_interests.concat(user.interests).uniq.sort_by(&:name)
  end
end
