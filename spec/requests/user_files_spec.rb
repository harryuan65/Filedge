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
    subject(:download_request) do
      get download_user_file_url(user_file)
    end

    before do
      sign_in(user)
      download_request
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "downloads the file" do
      expect(response.content_type).to eq(user_file.asset.content_type)
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
        user_file # trigger creation
      end

      pending "RSpec cannot catch request level exception. Need to catch NotFound and render a custom page"
      # it "does not destroy the requested user_file" do
      #   expect { delete_request }.not_to change(UserFile, :count)
      # end

      # it "raises a not found exception" do
      #   expect { delete_request }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find UserFile")
      # end
    end
  end
end
