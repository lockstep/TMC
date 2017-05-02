describe 'Conference', type: :feature do

  before do
    BreakoutSession.all.destroy_all
    @user = create(:user)
    @conference = create(:conference)
    @breakout_session_location = create(:breakout_session_location)
    @breakout_session = create(
      :breakout_session, organizers: [ @user ],
      location: @breakout_session_location
    )
    @undetermined_breakout_session = create(
      :breakout_session, organizers: [ @user ]
    )
    @timeslot = create(:breakout_session_location_timeslot, day: Date.today,
                      breakout_session: @breakout_session)
    @undetermined_timeslot = create(
      :breakout_session_location_timeslot, day: Date.tomorrow,
      start_time: nil, end_time: nil,
      breakout_session: @undetermined_breakout_session
    )
    @conference.update(
      breakout_session_locations: [ @breakout_session_location ],
      breakout_sessions: [ @breakout_session, @undetermined_breakout_session ]
    )
  end

  describe 'show' do
    before do
      visit conference_path(@conference)
    end
    it 'shows conference breakout session' do
      expect(page).to have_content "#{@conference.name.upcase}"
      session = @breakout_session
      start_time = "#{format_time(session.start_time)}"
      end_time = "#{format_time(session.end_time)}"
      expect(page).to have_content "#{start_time} - #{end_time}"
      expect(page).to have_content @user.full_name
      expect(page).to have_content @breakout_session.name
      expect(page).to have_content @breakout_session_location.name
      # For time of @undetermined_breakout_session
      expect(page).to have_content 'TBD'
    end
  end

  private

  def format_time(time)
    time.strftime("%H:%M")
  end

end
