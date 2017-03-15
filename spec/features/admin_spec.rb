describe 'Admin sections', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :posts

  let(:admin) { users(:michelle) }

  before { signin(admin.email, 'qawsedrf') }

  describe 'Dashboards index pages' do
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

  describe 'Dashboard search' do
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
