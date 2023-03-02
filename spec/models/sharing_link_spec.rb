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
RSpec.describe SharingLink do
  it { is_expected.to belong_to(:user_file) }

  it "is invalid without a user_file" do
    expect(described_class.new).not_to be_valid
  end
end
