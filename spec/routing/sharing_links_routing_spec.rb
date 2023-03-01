require "rails_helper"

RSpec.describe SharingLinksController do
  describe "routing" do
    let(:example_uuid) { "622964a3-2821-4655-8fbf-3623b3b393cb" }
    let(:example_sharing_link_digest) { Digest::SHA256.hexdigest("#{Time.now.to_i}#{Process.pid}#{Thread.current.object_id}#{example_uuid}") }

    it "routes to #show" do
      expect(get: "/share/#{example_sharing_link_digest}").to route_to("sharing_links#show", id: example_sharing_link_digest)
    end

    it "routes to #create" do
      expect(post: "/user_files/#{example_uuid}/share").to route_to("sharing_links#create", user_file_id: example_uuid)
    end
  end
end
