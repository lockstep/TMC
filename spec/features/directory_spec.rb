describe 'Directory', type: :feature do
  fixtures :users
  fixtures :certifications
  fixtures :interests

  before do
    @michelle = users(:michelle)
    @michelle.update(
      address_country: 'US',
      position: 'Montessori Guide',
      certifications: [certifications(:ami)],
      interests: [interests(:peace)],
      opted_in_to_public_directory: true
    )
    @paul = users(:paul)
    @paul.update(
      address_country: 'TH',
      position: 'Head of School',
      certifications: [certifications(:abc)],
      interests: [interests(:teaching)],
      opted_in_to_public_directory: true
    )
  end

  describe 'filter search' do
    context 'all users opted in to public directory' do
      context 'no filters' do
        it 'shows only opted in users' do
          visit directory_path
          expect(page).to have_content 'Michelle'
          expect(page).to have_content 'Paul'
        end
      end
      context 'certifications' do
        before do
          visit directory_path
        end
        it 'shows all public certification options' do
          expect(page).to have_content 'AMI'
          expect(page).to have_content 'ABC'
        end
        context 'an option selected' do
          before do
            check 'AMI'
          end
          it 'shows the user' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).not_to have_content 'Paul'
            expect(page).to have_content 'Michelle'
          end
        end
        context 'multiple options selected' do
          before do
            check 'AMI'
            check 'ABC'
          end
          it 'shows the users having either option' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).to have_content 'Paul'
            expect(page).to have_content 'Michelle'
          end
        end
      end
      context 'interests' do
        before do
          visit directory_path
        end
        it 'shows all public interest options' do
          expect(page).to have_content 'Peace'
          expect(page).to have_content 'Teaching'
        end
        context 'an option selected' do
          before do
            check 'Peace'
          end
          it 'shows the user' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).not_to have_content 'Paul'
            expect(page).to have_content 'Michelle'
          end
        end
        context 'multiple options selected' do
          before do
            check 'Peace'
            check 'Teaching'
          end
          it 'shows the users having either option' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).to have_content 'Paul'
            expect(page).to have_content 'Michelle'
          end
        end
      end
      context 'positions' do
        before do
          visit directory_path
        end
        it 'shows all position options' do
          User::POSITIONS.each do |position|
            expect(page).to have_content position
          end
        end
        context 'an option selected' do
          before do
            check 'Montessori Guide'
          end
          it 'shows the user' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).not_to have_content 'Paul'
            expect(page).to have_content 'Michelle'
          end
        end
        context 'multiple options selected' do
          before do
            check 'Montessori Guide'
            check 'Head of School'
          end
          it 'shows the users having either option' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).to have_content 'Paul'
            expect(page).to have_content 'Michelle'
          end
        end
      end
      context 'country' do
        before do
          visit directory_path
        end
        it 'shows country selection' do
          expect(page).to have_content 'Select Country'
        end
        context 'a country selected' do
          before do
            select 'Thailand'
          end
          it 'shows the user' do
            within '.search' do
              click_button 'Search'
            end
            expect(page).not_to have_content 'Michelle'
            expect(page).to have_content 'Paul'
          end
        end
      end
      context 'no records matched' do
        before do
          visit directory_path
        end
        it 'shows no records message' do
          check 'Material Maker'
          within '.search' do
            click_button 'Search'
          end
          expect(page)
            .to have_content I18n.t('directory.index.no_users_found')
        end
      end
      context 'user profile' do
        before do
          visit directory_profile_path(users(:michelle).id)
        end
        it 'does not show the profile but redirects back with warning message' do
          expect(page)
            .to have_current_path directory_profile_path(users(:michelle).id)
          expect(page)
            .to have_content users(:michelle).full_name.upcase
        end
      end
      context 'user is logged in and already in the directory' do
        before { @user = @michelle }
        include_context 'signed in user'
        it 'does not show join button' do
          visit directory_path
          expect(page).not_to have_link 'Join Directory'
        end
      end
    end
    context 'some user not opted in to public directory' do
      before do
        @paul.update(opted_in_to_public_directory: false)
        visit directory_path
      end
      context 'user wants to join' do
        it 'walks the user through the process' do
          click_link 'Join Directory'
          fill_sign_in_form(@paul.email, 'qawsedrf')
          click_button('Log in')
          expect(page).to have_field "user_first_name"
          fill_in 'user_first_name', with: 'p'
          fill_in 'user_last_name', with: 'p'
          check 'user_opted_in_to_public_directory'
          click_button 'Save profile'
          expect(page).to have_content I18n.t('devise.registrations.joined_directory')
        end
      end
      context 'no filters' do
        it 'shows only opted in users' do
          expect(page).to have_content 'Michelle'
          expect(page).not_to have_content 'Paul'
        end
      end
      context 'certifications' do
        context 'not opted in user certification selected' do
          before do
            check 'ABC'
            within '.search' do
              click_button 'Search'
            end
          end
          it 'does not show the user profile' do
            expect(page)
              .to have_content I18n.t('directory.index.no_users_found')
          end
        end
      end
      context 'interests' do
        context 'not opted in user interest selected' do
          before do
            check 'Teaching'
            within '.search' do
              click_button 'Search'
            end
          end
          it 'does not show the user profile' do
            expect(page)
              .to have_content I18n.t('directory.index.no_users_found')
          end
        end
      end
      context 'positions' do
        context 'not opted in user position selected' do
          before do
            check 'Head of School'
            within '.search' do
              click_button 'Search'
            end
          end
          it 'shows the users having either option' do
            expect(page)
              .to have_content I18n.t('directory.index.no_users_found')
          end
        end
      end
      context 'country' do
        context 'not opted in user country selected' do
          before do
            select 'Thailand'
            within '.search' do
              click_button 'Search'
            end
          end
          it 'shows the user' do
            expect(page)
              .to have_content I18n.t('directory.index.no_users_found')
          end
        end
      end
      context 'user profile' do
        before do
          visit directory_profile_path(users(:paul).id)
        end
        it 'does not show the profile but redirects back with warning message' do
          expect(page).to have_current_path(directory_path)
          expect(page)
            .to have_content I18n.t('directory.profile.user_not_found')
        end
      end
    end
  end
  describe 'query search' do
    before do
      visit directory_path
    end
    context 'first name' do
      it 'shows the specified user' do
        within '.query' do
          fill_in 'query', with: 'michelle'
          click_button 'Search'
        end
        expect(page).to have_content 'Michelle'
        expect(page).not_to have_content 'Paul'
      end
      context 'path of name' do
        it 'shows the specified user' do
          within '.query' do
            fill_in 'query', with: 'chel'
            click_button 'Search'
          end
          expect(page).to have_content 'Michelle'
          expect(page).not_to have_content 'Paul'
        end
      end
    end
    context 'last name' do
      it 'shows the specified user' do
        within '.query' do
          fill_in 'query', with: 'HIATT'
          click_button 'Search'
        end
        expect(page).to have_content 'Paul'
        expect(page).not_to have_content 'Michelle'
      end
    end
    context 'multiple names' do
      it 'shows the specified user' do
        within '.query' do
          fill_in 'query', with: 'HIATT chel'
          click_button 'Search'
        end
        expect(page).to have_content 'Paul'
        expect(page).to have_content 'Michelle'
      end
    end
    context 'interest' do
      it 'shows the specified user' do
        within '.query' do
          fill_in 'query', with: 'teaching'
          click_button 'Search'
        end
        expect(page).to have_content 'Paul'
        expect(page).not_to have_content 'Michelle'
      end
      context 'multiple interests' do
        it 'shows the specified user' do
          within '.query' do
            fill_in 'query', with: 'teaching peace'
            click_button 'Search'
          end
          expect(page).to have_content 'Paul'
          expect(page).to have_content 'Michelle'
        end
      end
      context 'private interest' do
        before do
          users(:paul).interests.create(name: 'private')
        end
        it 'shows the specified user' do
          within '.query' do
            fill_in 'query', with: 'private'
            click_button 'Search'
          end
          expect(page).not_to have_content 'Michelle'
          expect(page).to have_content 'Paul'
        end
      end
    end
    context 'certification' do
      it 'shows the specified user' do
        within '.query' do
          fill_in 'query', with: 'ami'
          click_button 'Search'
        end
        expect(page).not_to have_content 'Paul'
        expect(page).to have_content 'Michelle'
      end
      context 'multiple certifications' do
        it 'shows the specified user' do
          within '.query' do
            fill_in 'query', with: 'AMI abc'
            click_button 'Search'
          end
          expect(page).to have_content 'Paul'
          expect(page).to have_content 'Michelle'
        end
      end
      context 'private certification' do
        before do
          users(:michelle).interests.create(name: 'private')
        end
        it 'shows the specified user' do
          within '.query' do
            fill_in 'query', with: 'private'
            click_button 'Search'
          end
          expect(page).to have_content 'Michelle'
          expect(page).not_to have_content 'Paul'
        end
      end
    end

  end
end
