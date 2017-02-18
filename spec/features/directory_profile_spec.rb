feature 'Directory Profile', type: :feature do
  before do
    @vendor = create(:user, opted_in_to_public_directory: true)
    @user = create(:user, opted_in_to_public_directory: true)
  end
  feature 'vendor products shown below profile info' do
    before do
      @product = create(:product, vendor: @vendor)
    end
    it 'shows the vendors products on their page' do
      visit directory_profile_path(@vendor)
      expect(page).to have_content @product.name
    end
  end

  feature 'messaging a user' do
    context 'user is signed in' do
      include_context 'signed in user'

      it 'lets the user write a private message' do
        visit directory_profile_path(@vendor)
        fill_in 'feed_item_message', with: 'my message'
        click_button I18n.t('directory.profile.send_message')
        expect(page).to have_content I18n.t('feed_items.send_message.message_sent')
        expect(page).to have_content 'my message'
      end

      it 'forces the user to write something' do
        visit directory_profile_path(@vendor)
        click_button I18n.t('directory.profile.send_message')
        expect(page).to have_content I18n.t('feed_items.send_message.message_empty')
      end

      it 'lets the user view private messaegs' do
        create(:private_message, author: @vendor, feedable: @user)
        visit directory_profile_path(@vendor)
        expect(page).to have_content 'a private message'
      end

      context 'user is viewing themselves' do
        it 'does not let user send messages' do
          visit directory_profile_path(@user)
          expect(page).not_to have_field 'feed_item_message'
          expect(page).to have_content I18n.t('directory.profile.own_messages')
        end
      end

      context 'viewing user blocks all messages' do
        it 'does not let user post' do
          visit directory_profile_path(@vendor)
          click_link I18n.t('directory.profile.disable_all_messages')
          expect(page).to have_content I18n.t(
            'feed_policies.toggle_private_messages_enabled.all_messages_disabled'
          )
          fill_in 'feed_item_message', with: 'my message'
          click_button I18n.t('directory.profile.send_message')
          expect(page).to have_content I18n.t(
            'feed_items.send_message.self_messages_disabled'
          )
          click_link I18n.t('directory.profile.enable_all_messages')
          expect(page).to have_content I18n.t(
            'feed_policies.toggle_private_messages_enabled.all_messages_enabled'
          )
          fill_in 'feed_item_message', with: 'my message'
          click_button I18n.t('directory.profile.send_message')
          expect(page)
            .to have_content I18n.t('feed_items.send_message.message_sent')
        end
      end

      context 'viewing user is not in the public directory' do
        before do
          @user.update(opted_in_to_public_directory: false)
        end
        it 'does not let user send messages' do
          visit directory_profile_path(@vendor)
          expect(page).not_to have_field 'feed_item_message'
          expect(page).to have_content I18n.t('directory.profile.must_be_in_directory_for_messages_html').first(20)
        end
      end
    end
    context 'user is not signed in' do
      it 'asks user to sign in first' do
        visit directory_profile_path(@vendor)
        expect(page).not_to have_field 'feed_item_message'
        expect(page).to have_content 'to send messages'
      end
    end
  end
end
