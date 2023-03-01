RSpec.describe SharingLink do
  it { is_expected.to belong_to(:user_file) }

  it "is invalid without a user_file" do
    expect(described_class.new).not_to be_valid
  end
end
