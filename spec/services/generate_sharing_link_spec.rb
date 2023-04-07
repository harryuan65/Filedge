# frozen_string_literal: true

RSpec.describe GenerateSharingLink do
  let(:user_file) { create(:user_file, :with_user) }

  context "when link already exists" do
    before do
      create(:sharing_link, user_file: user_file)
    end

    it "does not create a new link" do
      expect { described_class.call(user_file) }.not_to change(SharingLink, :count)
    end
  end
end
