module ConferencesHelper

  def breakout_session_time(session)
    "#{format_time(session.start_time)} - #{format_time(session.end_time)}"
  end

  def format_date(session)
    return 'TBD' unless session.day
    session.day.strftime("%A %b %e")
  end

  def format_organizers(session)
    return 'TBD' if session.organizers.blank?
    session.organizers.map(&:full_name).reject(&:empty?).join(', ')
  end

  def format_location(session)
    return 'TBD' unless session.location
    session.location_name
  end

  private

  def format_time(time)
    return 'TBD' unless time.present?
    time.strftime("%H:%M")
  end
end
