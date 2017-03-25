describe 'Interest', type: :feature do
  fixtures :users
  fixtures :interests

  before do
    users(:paul).update(
      interests: [interests(:teaching)],
      opted_in_to_public_directory: true
    )
  end
  describe 'show' do
    before do
      visit interest_path(interests(:teaching).slug)
    end
    context 'user not signed in' do
      it 'displays breakout session informaiton' do
        expect(page).to have_content interests(:teaching).name.upcase
        expect(page).to have_content 'Please sign in or sign up to post comments'
        within 'section.add-interest' do
          expect(page).to have_content 'Please sign in or sign up'
        end
        within '.right-user-list' do
          expect(page).to have_content 'Paul'
        end
      end
    end
    context 'not in directory' do
      before do
        @user = users(:michelle)
        within 'section.post-comment' do
          click_on 'sign in'
        end
        signin(@user.email, 'qawsedrf')
      end
      it 'informs user must join directory' do
        expect(page).to have_content I18n.t(
          'feed_items.must_be_in_directory_to_post_html'
        )[0..10]
      end
    end
    context 'opted into directory' do
      before do
        @user = users(:michelle)
        @user.update(opted_in_to_public_directory: true)
      end
      context 'signed in' do
        before do
          within 'section.post-comment' do
            click_on 'sign in'
          end
          signin(@user.email, 'qawsedrf')
        end
        it 'redirects back to breakout session page' do
          expect(page).to have_current_path interest_path(
            interests(:teaching).slug
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
        context 'add the interest to profile' do
          context 'user is opted in to public directory' do
            before do
              users(:michelle).update(
                opted_in_to_public_directory: true
              )
            end
            it "shows the user's in interest list" do
              click_button 'ADD TO PROFILE'
              within '.right-user-list' do
                expect(page).to have_content users(:michelle).first_name
              end
            end
          end
        end

      end
    end
  end
end

