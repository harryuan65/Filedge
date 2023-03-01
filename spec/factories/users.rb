FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { SecureRandom.uuid }
    trait :with_an_item do
      association :user_file
    end
  end
end
