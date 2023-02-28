#
# Responsible for user files CRUD operations
#
class SharingLinksController < ApplicationController
  # sharing_link_path
  # /share/:id
  #
  def show
    link = SharingLink.includes(:user_file).find(sharing_link_params[:digest])
    if link&.expired?
      return render status: :not_found
    end
    @file = link.file
    render "user_files#show"
  end

  # POST user_file_sharing_links_path /user_files/:user_file_id/share
  def create
    link = SharingLink.find_by(user_file_id: @user_file.id)
    new_expire_at = 30.days.from_now
    if link&.expired?
      link.update(expire_at: new_expire_at)
    else
      @user_file.link.create!(expire_at: new_expire_at)
    end
  end

  private

  def set_user_file
    @user_file = UserFile.find(sharing_link_params[:user_file_id])
  end

  def sharing_link_params
    params.permit(:digest, :user_file_id)
  end
end
