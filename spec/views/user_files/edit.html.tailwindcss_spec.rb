require "rails_helper"

RSpec.describe "user_files/edit" do
  let(:user_file) { assign(:user_file, UserFile.create!) }

  it "renders the edit user_file form" do
    render

    assert_select "form[action=?][method=?]", user_file_path(user_file), "post" do
    end
  end
end
