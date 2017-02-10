describe Certification, type: :model do
  fixtures :users
  fixtures :certifications

  describe 'validations' do
    context 'public name' do
      it 'does not create duplicate public name' do
        certification = Certification.create(name: certifications(:ami).name,
                                             public: true)
        expect(certification.valid?).to eq false
        expect(certification.errors.full_messages.first)
          .to match 'Name has already been taken'
      end
    end
  end
  describe 'manage certifications' do
    context 'has public certifications' do
      before do
        @user = users(:default)
      end
      it 'updates user with new interset' do
        Certification.manage_user_certifications(@user, ['AMI'])
        expect(@user.reload.certifications.find_by(name: 'AMI')).not_to eq nil
      end
      context 'user has a public certification' do
        before do
          @certification_count = Certification.all.count
          @user.update(certifications: [certifications(:ami)])
        end
        it 'creates user private certification' do
          Certification.manage_user_certifications(@user, ['Custom'])
          certification_names = @user.reload.certifications.pluck(:name)
          expect(certification_names.include?('Custom')).to eq true
          expect(Certification.find_by(name: 'AMI')).not_to eq nil
          expect(Certification.all.count).to eq @certification_count + 1
        end
      end
      context 'user has public and private certifications' do
        before do
          certification_1 = certifications(:ami)
          certification_2 = certifications(:private)
          @certification_count = Certification.all.count
          @user.update(certifications: [certification_1, certification_2])
        end
        it 'deletes unused user certification' do
          Certification.manage_user_certifications(@user, ['Custom'])
          certification_names = @user.reload.certifications.pluck(:name)
          expect(certification_names.include?('Custom')).to eq true
          expect(certification_names.length).to eq 1
          expect(Certification.find_by(name: 'Private')).to eq nil
        end
      end
      context 'update with same certification name' do
        before do
          @user.update(certifications: [certifications(:ami), certifications(:private)])
        end
        it 'does not create duplicate certification' do
          Certification.manage_user_certifications(
            @user, ['AMI', 'ABC', 'Custom'])
          expect(Certification.where(name: 'AMI').count).to eq 1
          expect(Certification.where(name: 'ABC').count).to eq 1
          expect(Certification.where(name: 'Custom').count).to eq 1
        end
      end
    end
  end
end
