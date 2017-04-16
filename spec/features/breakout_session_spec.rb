describe 'BreakoutSession', type: :feature do
  before do
    @conference = create(:conference)
    @breakout_session = create(:breakout_session)
    @breakout_session_location = create(:breakout_session_location)
    @breakout_session.update(location: @breakout_session_location)
    @organizer = create(:user, first_name: 'Paul')
  end

  describe 'apply for breakout session' do
    
  end

  describe 'show' do
    before do
      @conference.update(breakout_sessions: [ @breakout_session ])
      @breakout_session.update(organizers: [ @organizer ])
      visit breakout_session_path(@breakout_session.slug)
    end
    context 'user not signed in' do
      it 'displays breakout session informaiton' do
        expect(page).to have_content @breakout_session.name.upcase
        expect(page).to have_content 'Please sign in or sign up to post comments'
        within 'section.join' do
          expect(page).to have_content 'Please sign in or sign up'
        end
        within '.organizers' do
          expect(page).to have_content 'Paul'
        end
      end
    end
    context 'signed in' do
      before do
        within 'section.post-comment' do
          click_on 'sign in'
        end
        @user = create(:user, first_name: 'Michelle')
        @user.update(opted_in_to_public_directory: true)
        signin(@user.email, 'password')
      end
      it 'redirects back to breakout session page' do
        expect(page).to have_current_path breakout_session_path(
          @breakout_session.slug
        )
      end
      context 'post message' do
        context 'valid message' do
          it 'shows the message' do
            fill_in('feed_item_message', with: 'hello world')
            click_button 'POST'
            expect(page).to have_content 'comment has been save'
            within 'section.comments' do
              expect(page).to have_content 'hello world'
            end
          end
        end
        context 'invalid message' do
          it 'shows the message' do
            click_button 'POST'
            expect(page).to have_content "didn't add a comment"
            within 'section.comments' do
              expect(page).not_to have_content 'hello world'
            end
          end
        end
      end
      context 'join the session' do
        context 'user is opted in to public directory' do
          before do
            @user.update(
              opted_in_to_public_directory: true
            )
          end
          it "shows the user's in attendee list" do
            click_button 'JOIN SESSION'
            within '.right-user-list' do
              expect(page).to have_content @user.first_name
            end
          end
        end
        context 'user is not opted in to public directory' do
          before do
            @user.update(opted_in_to_public_directory: false)
          end
          it 'shows warning and does not list the user in attendee list' do
            click_button 'JOIN SESSION'
            expect(page).to have_content 'must be listed in The Montessori Directory'
            within '.right-user-list' do
              expect(page).not_to have_content @user.first_name
            end
          end
        end
      end
    end
  end

end
