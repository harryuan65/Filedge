# == Schema Information
#
# Table name: sharing_links
#
#  digest       :string           not null, primary key
#  user_file_id :uuid             not null
#  expire_at    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
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
