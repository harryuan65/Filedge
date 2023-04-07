RSpec.describe "/user_files" do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  let(:valid_attributes) do
    example_file_path = file_fixture("example_file.txt")
    {asset: Rack::Test::UploadedFile.new(example_file_path), file_size: example_file_path.open("r").size}
  end

  let(:invalid_attributes) do
    {asset: nil}
  end
  let(:user_file) { user.files.create!(valid_attributes) }

  describe "GET /index" do
    context "with user session" do
      before { sign_in(user) }

      it "renders a successful response" do
        get user_files_url
        expect(response).to be_successful
      end

      it "renders existing user_files" do
        user_file # trigger creation
        get user_files_url
        expect(response.body).to include(user_file.asset.filename)
      end
    end

    context "without user session" do
      it "redirects to sign in page" do
        get user_files_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /show" do
    before do
      sign_in(user)
      get user_file_url(user_file)
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "renders a page with user_file information" do
      expect(response.body).to include(user_file.asset.filename)
    end
  end

  describe "GET /download" do
    context "when file's sharing_link expired" do
      let(:user_file_with_expired_link) { create(:user_file, :with_expired_link, user_id: user.id) }

      context "when the owner is performing the download" do
        before do
          sign_in(user)
          get download_user_file_url(user_file_with_expired_link)
        end

        it("renders a successful response") { expect(response).to be_successful }
        it("sends the file") { expect(response.content_type).to eq(user_file_with_expired_link.asset.content_type) }
      end

      context "when other users are performing the download" do
        before do
          sign_in(user2)
          get download_user_file_url(user_file_with_expired_link)
        end

        it("renders a forbidden response to other users") { expect(response).to have_http_status(:forbidden) }

        it("sends nothing to other users") { expect(response.body).to be_empty }
      end
    end

    context "when file's sharing_link is valid" do
      let(:user_file_with_valid_link) { create(:user_file, :with_valid_link, user_id: user.id) }

      context "when the owner is performing the download" do
        before do
          sign_in(user)
          get download_user_file_url(user_file_with_valid_link)
        end

        it("renders a successful response") { expect(response).to have_http_status(:ok) }
        it("sends the file") { expect(response.content_type).to eq(user_file_with_valid_link.asset.content_type) }
      end

      # Future: access list instead of allowing all
      context "when other users are performing the download" do
        before do
          sign_in(user2)
          get download_user_file_url(user_file_with_valid_link)
        end

        it("renders a successful response") { expect(response).to have_http_status(:ok) }
        it("sends the file") { expect(response.content_type).to eq(user_file_with_valid_link.asset.content_type) }
      end
    end
  end

  # Format: turbo stream
  describe "POST /create" do
    context "with user session and valid parameters" do
      subject(:valid_post_request) do
        post user_files_url, params: {user_file: valid_attributes, progress_bar_id: "progress_1"}, headers: {accept: "text/vnd.turbo-stream.html"}
      end

      before { sign_in(user) }

      it "creates a new UserFile" do
        expect { valid_post_request }.to change(UserFile, :count).by(1)
      end

      it "renders a turbo stream response" do
        valid_post_request
        dom_id_string = "user_file_#{UserFile.last.id}"
        # expect(response).to render_template("create.turbo_stream.erb") # I don't want to install another gem just for this line. Maybe in the future?
        expect(response.body).to include(dom_id_string)
      end
    end

    context "with invalid parameters" do
      subject(:invalid_post_request) do
        post user_files_url, params: {user_file: invalid_attributes}, headers: {accept: "text/vnd.turbo-stream.html"}
      end

      it "does not create a new UserFile" do
        expect { invalid_post_request }.not_to change(UserFile, :count)
      end

      it "redirects to sign in page(handled by devise)" do
        invalid_post_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /destroy" do
    subject(:delete_request) do
      delete user_file_url(user_file)
    end

    context "with owner" do
      before do
        sign_in(user)
        user_file # trigger creation
      end

      it "destroys the requested user_file" do
        expect { delete_request }.to change(UserFile, :count).by(-1)
      end

      it "redirects to the user_files list" do
        delete_request
        expect(response).to redirect_to(user_files_url)
      end
    end

    context "with other users" do
      before do
        sign_in(user2)
      end

      it "renders a not found response" do
        delete_request
        expect(response).to have_http_status(:not_found)
      end

      it "does not destroy the requested user_file" do
        user_file # trigger creation first
        expect { delete_request }.not_to change(UserFile, :count)
      end
    end
  end
end
