#
# Responsible for user files CRUD operations
#
class UserFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_file, only: %i[show destroy download]

  # The index page of files.
  # GET /user_files
  def index
    files = current_user.files
    @user_files = files.all
    @user_file = files.new
  end

  # The info page of a file.
  # GET /user_files/1
  def show
  end

  # GET /user_files/1/download
  def download
    #   if current_user.id == @user_file.user_id
    #
    #   else
    #
    #   end
    asset = @user_file.asset
    send_file asset.path, type: asset.content_type
  end

  # POST /user_files [Turbo Stream]
  # Create a UserFile.
  # This is called from stimulus upload_controller after the file field is changed.
  def create
    @user_file = current_user.files.new(asset: user_file_params[:asset])

    respond_to do |format|
      format.turbo_stream do
        if @user_file.save
          @progress_bar_id = progress_bar_id
          flash.notice = I18n.t("models.user_files.uploaded", file_name: @user_file.asset.identifier)
        else
          flash.alert = @user_file.errors.full_messages.join("\n")
        end
      end
    end
  end

  # DELETE /user_files/1
  def destroy
    @user_file.destroy
    redirect_to user_files_url, notice: I18n.t("models.user_files.destroyed", file_name: @user_file.asset.identifier)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_file
    @user_file = current_user.files.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_file_params
    params.fetch(:user_file, {})
  end

  def progress_bar_id
    params.permit(:progress_bar_id, user_file: {}).fetch(:progress_bar_id)
  end
end
