# == Schema Information
#
# Table name: user_files
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  asset      :string           not null
#  file_size  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user_file do
    asset { Rails.root.join("spec/factories/user_files.rb").open("r") }
    file_size { asset.size }
    trait :with_link do
      association :sharing_link
    end

    trait :with_user do
      association :user
    end
  end
end
