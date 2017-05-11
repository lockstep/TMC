require 'csv'

module Admin
  class BreakoutSessionImport
    include ActiveModel::Model
    attr_accessor :conference_id, :import_file, :conference

    def import!
      self.conference = Conference.find(conference_id)
      CSV.foreach(
        import_file.path,
        encoding: "iso-8859-1:utf-8",
        :headers => true
      ) { |row| import_row(row) }
    end

    private

    def import_row(row)
      return unless organizer = find_organizer(row)
      find_or_create_breakout_session(row, organizer)
    end

    def find_organizer(row)
      email = row['Email Address']&.strip&.downcase
      return if email.blank?
      User.opted_in_to_public_directory.find_by(email: email)
    end

    def find_or_create_breakout_session(row, organizer)
      breakout_session = conference.breakout_sessions.detect do |b|
        b.organizers.include?(organizer)
      end
      unless breakout_session
        breakout_session = conference.breakout_sessions.create!(
          organizers: [ organizer ], name: determine_breakout_session_name(row)
        )
      end
      save_breakout_session_details(row, breakout_session)
    end

    def save_breakout_session_details(row, breakout_session)
      breakout_session_location = find_or_create_breakout_session_location(row)
      breakout_session_location.update(breakout_session: breakout_session)
      assign_breakout_session_location_timeslot(
        row, breakout_session, breakout_session_location
      )
      breakout_session.update!(
        name: determine_breakout_session_name(row),
        description: determine_breakout_session_description(row, breakout_session),
        approved: true
      )
    end

    def find_or_create_breakout_session_location(row)
      conference.breakout_session_locations.find_or_create_by(
        name: row['Room'].strip, capacity: row['Capacity']
      )
    end

    def assign_breakout_session_location_timeslot(row, breakout_session, breakout_session_location)
      breakout_session.breakout_session_location_timeslot&.update(
        breakout_session: nil
      )
      start_time = row['Time'].split('-')[0].strip
      end_time = row['Time'].split('-')[1].strip
      day = Date.strptime(row['Date'].strip, '%e/%m/%y')
      timeslot = breakout_session_location.breakout_session_timeslots.find_or_create_by(
        start_time: start_time, end_time: end_time, day: day
      )
      timeslot.update(breakout_session: breakout_session)
    end

    def determine_breakout_session_name(row)
      row['Title of presentation']&.strip
    end

    def determine_breakout_session_description(row, breakout_session)
      description = row['Short title']&.strip || ''
      if description.size < 40 || description.size <= breakout_session.name.size
        return nil
      end
      description
    end
  end
end
