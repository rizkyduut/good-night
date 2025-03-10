FactoryBot.define do
  factory :sleep_record do
    user
    clock_in { Time.current }
    clock_out { nil }
    duration { nil }
  end
end