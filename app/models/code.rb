class Code < ActiveRecord::Base
  validates :code, 
    numericality: { only_integer: { greater_than: 0 } },
    presence: true,
    uniqueness: { scope: [:time, :track_id]}

  validates :time, 
    numericality: { only_integer: { greater_than: 0 } },
    presence: true
  validates :track_id, presence: true

  belongs_to :track
end