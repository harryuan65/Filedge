FactoryBot.define do
  factory :sharing_link do
    association :user_file
    digest { Digest::SHA256.hexdigest(user_file.id) }
    expire_at { 30.days.from_now }
    trait :expired do
      expire_at { 1.day.ago }
    end
  end
end
