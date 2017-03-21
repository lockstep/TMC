describe 'Conference', type: :feature do
  fixtures :users
  fixtures :conferences
  fixtures :breakout_sessions
  fixtures :breakout_session_locations

  before do
    breakout_sessions(:teaching).update(
      organizers: [users(:paul)],
      location: breakout_session_locations(:big_room)
    )
    conferences(:ami).update(
      breakout_session_locations: [breakout_session_locations(:big_room)],
      breakout_sessions: [breakout_sessions(:teaching)]
    )
  end

  describe 'show' do
    before do
      visit conference_path(conferences(:ami).slug)
    end
    it 'shows conference brekout session' do
      expect(page).to have_content "#{conferences(:ami).name}"
      expect(page).to have_content Date.today.strftime("%m/%d/%y")
      session = breakout_sessions(:teaching)
      start_time = "#{format_time(session.starts_at)}"
      end_time = "#{format_time(session.ends_at)}"
      expect(page)
        .to have_content "#{start_time} - #{end_time}"
      expect(page).to have_content users(:paul).full_name
      expect(page).to have_content breakout_sessions(:teaching).name
      expect(page)
        .to have_content breakout_session_locations(:big_room).name
    end
  end

  private

  def format_time(time)
    time.strftime("%H:%M")
  end

end
