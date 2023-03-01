require "rails_helper"

# rubocop:disable RSpec/ExampleLength
RSpec.describe "user_files/show" do
  let(:user) { create(:user) }
  let(:file) { create(:user_file, user: user) }

  before do
    assign(:user_file, file)
  end

  it "renders the file information" do
    render
    assert_select "tbody tr" do
      assert_select "td", file.file_size.to_s
      assert_select "td", file.created_at.strftime("%b %d, %Y")
      assert_select "td form:match('action', ?)", Regexp.new("/user_files/#{file.id}")
    end
  end
end
# rubocop:enable RSpec/ExampleLength
