RSpec.describe "/sharing_link" do
  let(:user) { create(:user) }
  let(:user_file) { create(:user_file, user: user) }

  let(:valid_link) { create(:sharing_link, user_file: user_file) }
  let(:expired_link) { create(:sharing_link, :expired, user_file: user_file) }

  describe "GET /show" do
    before do
      sign_in(user)
    end

    context "when link is still valid" do
      it "renders a successful response" do
        get sharing_link_url(valid_link)
        expect(response).to be_successful
      end

      it "renders a page with user_file information" do
        get sharing_link_url(valid_link)
        expect(response.body).to include(user_file.asset.filename)
      end
    end

    context "when the link expired" do
      it "renders a not found response" do
        get sharing_link_url(expired_link)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /create" do
    subject(:create_sharing_link_for_a_file) do
      post user_file_sharing_links_url(user_file)
    end

    context "when the file link already exists" do
      before do
        sign_in(user)
        valid_link # trigger link creation
      end

      it "does not create a new link" do
        expect { create_sharing_link_for_a_file }.not_to change(SharingLink, :count)
      end

      it "renders a url" do
        create_sharing_link_for_a_file
        expect(response.body).to match(/\/share\//)
      end
    end

    context "when the file link does not exist" do
      before do
        sign_in(user)
      end

      it "creates a new link" do
        expect { create_sharing_link_for_a_file }.to change(SharingLink, :count).by(1)
      end

      it "renders a url" do
        create_sharing_link_for_a_file
        expect(response.body).to match(/\/share\//)
      end
    end

    context "without user session" do
      it "redirects to the sign in page" do
        create_sharing_link_for_a_file
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
