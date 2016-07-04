class Promotion < ActiveRecord::Base
  before_save :downcase_code

  validates :code, presence: true,
    uniqueness: { allow_blank: false, case_sensitive: false }
  validates :percent,
    numericality: { greater_than: 0, allow_nil: false, less_than: 100 }

  def active?
    (starts_at.nil? || starts_at < Time.current) &&
      (expires_at.nil? || expires_at > Time.current)
  end

  def inactive?
    !active?
  end

  private

  def downcase_code
    self.code = code.downcase
  end
end
