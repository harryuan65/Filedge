FactoryBot.define do
  factory :user_file do
    asset { Rails.root.join("spec/factories/user_files.rb").open("r") }
    file_size { asset.size }
    trait :with_link do
      association :sharing_link
    end
  end
end
