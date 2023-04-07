#
# Responsible for user files CRUD operations
#
class SharingLinksController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_user_file, only: %i[create]

  # View shared file page
  # GET /share/:id
  def show
    link = SharingLink.includes(:user_file).find(sharing_link_params[:id])
    if link&.expired?
      return render template: "shared/not_found", status: :not_found
    end
    @user_file = link.user_file
    render template: "user_files/show"
  end

  # Create a sharing link for a user file.
  # POST user_file_sharing_links_path /user_files/:user_file_id/share
  def create
    link = GenerateSharingLink.call(@user_file)
    render plain: sharing_link_url(link)
  end

  private

  def set_user_file
    @user_file = UserFile.find(sharing_link_params[:user_file_id])
  end

  def sharing_link_params
    params.permit(:id, :user_file_id)
  end
end
