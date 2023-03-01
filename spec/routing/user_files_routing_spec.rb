RSpec.describe UserFilesController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user_files").to route_to("user_files#index")
    end

    it "routes to #show" do
      expect(get: "/user_files/1").to route_to("user_files#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/user_files").to route_to("user_files#create")
    end

    it "routes to #destroy" do
      expect(delete: "/user_files/1").to route_to("user_files#destroy", id: "1")
    end
  end
end
