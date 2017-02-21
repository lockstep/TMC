describe 'BreakoutSession', type: :feature do
  fixtures :users
  fixtures :conferences
  fixtures :breakout_sessions
  fixtures :breakout_session_locations

  before do
    conferences(:ami).update(
      breakout_sessions: [breakout_sessions(:teaching)]
    )
    breakout_sessions(:teaching).update(
      organizers: [users(:paul)]
    )
  end

  describe 'show' do
    before do
      visit breakout_session_conference_path(
        conferences(:ami).slug, breakout_sessions(:teaching).slug
      )
    end
    context 'user not signed in' do
      it 'displays breakout session informaiton' do
        expect(page).to have_content breakout_sessions(:teaching).name.upcase
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
        signin(users(:michelle).email, 'qawsedrf')
      end
      it 'redirects back to breakout session page' do
        expect(page).to have_current_path breakout_session_conference_path(
          conferences(:ami).slug, breakout_sessions(:teaching).slug
        )
      end
      context 'post message' do
        context 'valid message' do
          it 'shows the message' do
            fill_in('feed_item_message', with: 'hello world')
            click_button 'POST'
            expect(page).to have_content 'message has been sent'
            within 'section.comments' do
              expect(page).to have_content 'hello world'
            end
          end
        end
        context 'invalid message' do
          it 'shows the message' do
            click_button 'POST'
            expect(page).to have_content "didn't add a message"
            within 'section.comments' do
              expect(page).not_to have_content 'hello world'
            end
          end
        end
      end
      context 'join the session' do
        context 'user is opted in to public directory' do
          before do
            allow_any_instance_of(User)
              .to receive(:opted_in_to_public_directory?) { true }
          end
          it "shows the user's in attendee list" do
            click_button 'JOIN SESSION'
            within '.attendees' do
              expect(page).to have_content users(:michelle).first_name
            end
          end
        end
        context 'user is not opted in to public directory' do
          it 'shows warning and does not list the user in attendee list' do
            click_button 'JOIN SESSION'
            expect(page).to have_content 'must be listed in The Montessori Directory'
            within '.attendees' do
              expect(page).not_to have_content users(:michelle).first_name
            end
          end
        end
      end
    end
  end

end
