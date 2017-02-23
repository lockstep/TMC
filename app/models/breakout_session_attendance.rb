class BreakoutSessionAttendance < ActiveRecord::Base
  belongs_to :user, -> { where(opted_in_to_public_directory: true) }
  belongs_to :breakout_session

  validate :user_must_have_opted_into_public_directory

  private

  def user_must_have_opted_into_public_directory
    return if user.opted_in_to_public_directory?
    errors.add :base, I18n.t('errors.must_have_opted_in_to_public_directory')
  end

end

