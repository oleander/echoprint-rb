FactoryGirl.define do
  factory :code do
    sequence(:code) {|n| n}
    sequence(:time) {|n| n}
    track
  end

  factory :track do
    version Track::VERSION
    external_id { SecureRandom.uuid }
    duration 100
  end
end