FactoryBot.define do
  factory :sharing_link do
    association :user_file
    digest { Digest::SHA256.hexdigest(user_file.id) }
  end
end
