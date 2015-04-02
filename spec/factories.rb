FactoryGirl.define do
  factory :code do
    sequence(:code) {|n| n}
    sequence(:time) {|n| n}
    track
  end

  factory :track do
    codever Track::VERSION
    sequence(:external_id) { |n| "external-id-#{n}" }
  end
end