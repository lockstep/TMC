describe 'Admin sections', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :posts

  let(:admin) { users(:michelle) }

  describe 'Dashboards index pages' do
    before { signin(admin.email, 'qawsedrf') }

    DashboardManifest::DASHBOARDS.each do |dashboard|
      context dashboard do
        it 'is a working admin dashboard' do
          visit "/admin/#{dashboard}"
          within '.header' do
            expect(page).to have_content dashboard.to_s.titleize
          end
        end
      end
    end
  end

  describe 'Searches' do
    context 'signed in user' do
      before { signin(admin.email, 'qawsedrf') }

      it 'is accessible' do
        visit admin_searchjoy_path
        expect(page).to have_content 'Searchjoy'
      end
    end

    context 'guest user' do
      it 'cannot peek under the hood' do
        visit admin_searchjoy_path
        expect(page).to have_current_path(new_user_session_path)
        within '#flash_alert' do
          expect(page).to have_content "Please sign in or sign up"
        end
      end
    end
  end

  describe 'Dashboard search' do
    before { signin(admin.email, 'qawsedrf') }

    describe 'Users' do
      it 'is a working search' do
        visit "/admin/users?search=mich"
        within '.collection-data' do
          expect(page).to have_content admin.email
        end
      end
    end

    describe 'Products' do
      it 'is a working search' do
        flamingo = products(:flamingo)
        visit "/admin/products?search=flamingo"
        within '.collection-data' do
          expect(page).to have_content flamingo.name
        end
      end
    end

    describe 'Posts' do
      it 'searches in post body as well' do
        blog = posts(:hello_tmc)
        visit "/admin/posts?search=physician"
        within '.collection-data' do
          expect(page).to have_content blog.title
        end
      end
    end
  end
end
