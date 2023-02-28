require "rails_helper"

RSpec.describe "user_files/show" do
  before do
    @user_file = assign(:user_file, UserFile.create!)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to contain("Back to user_files")
  end
end
