require "rails_helper"

RSpec.describe "user_files/index" do
  before do
    assign(:user_files, [
      UserFile.create!,
      UserFile.create!
    ])
  end

  it "renders a list of user_files" do
    render
    expect(rendered).to contain("Show this user file")
  end
end
