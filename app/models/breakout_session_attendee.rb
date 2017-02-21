class BreakoutSessionAttendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :breakout_session

  validate :user_must_opted_in_to_public_directory

  private

  def user_must_opted_in_to_public_directory
    return if user.opted_in_to_public_directory?
    errors.add :base, 'user must opted in to public directory'
  end

end

