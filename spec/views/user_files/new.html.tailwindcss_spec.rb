require "rails_helper"

RSpec.describe "user_files/new" do
  before do
    assign(:user_file, UserFile.new)
  end

  it "renders new user_file form" do
    render

    assert_select "form[action=?][method=?]", user_files_path, "post" do
    end
  end
end
