describe 'retrieving breakout sessions for conference', type: :request do
  describe 'GET /api/v1/conferences/:id/breakout_sessions' do
    context 'breakout session exists' do
      before do
        @conference = create(:conference)
        @breakout_session_location = create(:breakout_session_location)
        @breakout_session = create(
          :breakout_session,
          location: @breakout_session_location
        )
        @timeslot = create(
          :breakout_session_location_timeslot,
          day: Date.today,
          breakout_session: @breakout_session
        )
        @conference.update(
          breakout_session_locations: [ @breakout_session_location ],
          breakout_sessions: [ @breakout_session ]
        )
      end

      context '@user is authenticated' do
        before {
          @user = create(:user)
        }
        it 'should return correct data of breakout session' do
          get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
            auth_headers(@user)
          breakout_session = response_json['breakout_sessions'][0]
          expect(breakout_session['name']).to eq @breakout_session.name
          expect(breakout_session['location_name'])
            .to eq @breakout_session_location.name
          expect(breakout_session['day'])
            .to eq @timeslot.day.strftime('%A %b %e')
          expect(breakout_session['organizers'])
            .to eq []
        end
        context 'a breakout session has many organizers' do
          before do
            @organizer = create(
              :user,
              first_name: 'John',
              last_name: 'Doe'
            )
            @breakout_session.update(organizers: [ @user, @organizer ])
          end
          it 'should return organizers correctly' do
            get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
              auth_headers(@user)
            breakout_session = response_json['breakout_sessions'][0]
            organizers = breakout_session['organizers']
            expect(organizers.size).to eq 2
            expect(organizers[1]['full_name']).to eq 'John Doe'
          end
        end
        context 'another breakout session created' do
          before do
            @breakout_session_location_2 = create(:breakout_session_location)
            @breakout_session_2 = create(
              :breakout_session,
              name: 'painting',
              slug: 'painting',
              location: @breakout_session_location_2
            )
            create(
              :breakout_session_location_timeslot,
              day: Date.today,
              breakout_session: @breakout_session_2
            )
            @conference.update(
              breakout_session_locations: [ 
                @breakout_session_location,
                @breakout_session_location_2
              ],
              breakout_sessions: [
                @breakout_session,
                @breakout_session_2
              ]
            )
          end
          it 'should return a list of breakout sessions correctly' do
            get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
              auth_headers(@user)
            breakout_sessions = response_json['breakout_sessions']
            breakout_session = breakout_sessions[1]
            expect(breakout_sessions.size).to eq 2
            expect(breakout_session['name']).to eq @breakout_session_2.name
          end
          context 'non-approved breakout session exists' do
            before do
              @breakout_session_2.update(approved: false)
            end
            it 'does not return a non-approved breakout session' do
              get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
                auth_headers(@user)
              breakout_sessions = response_json['breakout_sessions']
              expect(breakout_sessions.size).to eq 1
            end
          end
        end
      end

      context 'unauthenticated user' do
        before do
          get "/api/v1/conferences/#{@conference.id}/breakout_sessions"
        end
        it_behaves_like 'an unauthorized request'
      end
    end

  end

  describe 'GET /api/v1/breakout_sessions/:id' do
    context 'a breakout session exists' do
      before do
        @conference = create(:conference)
        @breakout_session_location = create(:breakout_session_location)
        @breakout_session = create(
          :breakout_session,
          location: @breakout_session_location
        )
        @timeslot = create(
          :breakout_session_location_timeslot,
          day: Date.today,
          breakout_session: @breakout_session
        )
        @conference.update(
          breakout_session_locations: [ @breakout_session_location ],
          breakout_sessions: [ @breakout_session ]
        )
      end

      context '@user is authenticated' do
        before {
          @user = create(:user)
        }
        it 'should return the correct data of a single breakout session' do
          get "/api/v1/breakout_sessions/#{@breakout_session.id}",
            auth_headers(@user)
          breakout_session = response_json['breakout_session']
          expect(breakout_session['name']).to eq @breakout_session.name
          expect(breakout_session['location_name'])
            .to eq @breakout_session_location.name
          expect(breakout_session['day'])
            .to eq @timeslot.day.strftime('%A %b %e')
          expect(breakout_session['organizers'])
            .to eq []
        end
        context 'non-approved breakout session exists' do
          before do
            @breakout_session.update(approved: false)
          end
          it 'provides proper error' do
            get "/api/v1/breakout_sessions/#{@breakout_session.id}",
              auth_headers(@user)
            expect(response_json["meta"]["errors"]["message"])
              .to include 'resource not found'
          end
        end
      end

      context 'unauthenticated user' do
        before do
          get "/api/v1/breakout_sessions/#{@breakout_session.id}"
        end
        it_behaves_like 'an unauthorized request'
      end
    end
  end
end
