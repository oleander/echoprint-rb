class Code < ActiveRecord::Base
  validates :code, 
    presence: true,
    uniqueness: { scope: [:time, :track_id]}

  validates :time, 
    presence: true
  validates :track_id, presence: true

  validate :validate_code
  validate :validate_time

  belongs_to :track

  private

  def validate_code
    if code and code < 0
      errors.add(:code, "can't be < 0")
    end
  end

  def validate_time
    if time and time < 0
      errors.add(:time, "can't be < 0")
    end
  end
end