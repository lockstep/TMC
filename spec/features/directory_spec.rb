describe 'Directory', type: :feature do
  fixtures :users
  fixtures :certifications
  fixtures :interests

  before do
    users(:michelle).update(
      address_country: 'US',
      position: 'Montessori Guide',
      certifications: [certifications(:ami)],
      interests: [interests(:peace)]
    )
    users(:paul).update(
      address_country: 'TH',
      position: 'Head of School',
      certifications: [certifications(:abc)],
      interests: [interests(:teaching)]
    )
  end

  describe 'search' do
    context 'no filters' do
      it 'shows all certifications and users' do
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
          click_button 'Search'
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
          click_button 'Search'
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
          click_button 'Search'
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
          click_button 'Search'
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
          click_button 'Search'
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
          click_button 'Search'
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
          click_button 'Search'
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
        click_button 'Search'
        expect(page)
          .to have_content 'No users with defined specifications have been found'
      end
    end
  end
end
