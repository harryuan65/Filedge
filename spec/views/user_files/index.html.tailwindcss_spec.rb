require "rails_helper"

RSpec.describe "user_files/index" do
  let(:user) { create(:user) }
  let!(:files) { create_list(:user_file, 3, user: user) }

  before do
    assign(:user_file, user.files.new)
    assign(:user_files, files)
  end

  it "renders a list of user_files" do
    render
    regex = Regexp.union(files.map { |file| dom_id(file) })
    expect(rendered).to match(regex)
  end
end
