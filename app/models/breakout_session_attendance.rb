class BreakoutSessionAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :breakout_session

  validate :user_must_have_opted_into_public_directory

  private

  def user_must_have_opted_into_public_directory
    return if user.opted_in_to_public_directory?
    errors.add :base,
      I18n.t('breakout_sessions.join_session.profile_must_be_listed_in_the_directory')
  end

end

