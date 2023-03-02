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
RSpec.describe UserFile do
  let(:valid_user_file) { create(:user_file, :with_user) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:sharing_link) }

  it "is valid with both user and asset" do
    expect(valid_user_file).to be_valid
  end

  it "is invalid without a user" do
    valid_user_file.user = nil
    expect(valid_user_file).not_to be_valid
  end

  it "is invalid without an asset" do
    valid_user_file.asset = nil
    expect(valid_user_file).not_to be_valid
  end
end
