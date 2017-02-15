module ConferencesHelper

  def breakout_session_time(session)
    "#{format_time(session.start_time)} - #{format_time(session.end_time)}"
  end

  def format_organizers(session)
    return 'N/A' if session.organizers.blank?
    session.organizers.map(&:full_name).reject(&:empty?).join(', ')
  end

  def format_location(session)
    return 'N/A' unless session.location
    session.location.name
  end

  private

  def format_time(time)
    return 'N/A' unless time.present?
    time.strftime("%H:%M")
  end
end
