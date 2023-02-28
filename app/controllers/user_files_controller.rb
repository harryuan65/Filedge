#
# Responsible for user files CRUD operations
#
class UserFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_file, only: %i[show edit update destroy download]

  # GET /user_files or /user_files.json
  def index
    files = current_user.files
    @user_files = files.all
    @user_file = files.new
  end

  # GET /user_files/1 or /user_files/1.json
  def show
  end

  def download
    asset = @user_file.asset
    send_file asset.path, type: asset.file.content_type
  end

  # GET /user_files/1/edit
  def edit
  end

  # POST /user_files or /user_files.json
  def create
    @user_file = current_user.files.new(asset: user_file_params[:asset])

    if @user_file.save
      redirect_to user_file_url(@user_file), notice: I18n.t("models.user_files.created")
    else
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_files/1 or /user_files/1.json
  def update
    if @user_file.update(user_file_params)
      redirect_to user_file_url(@user_file), notice: I18n.t("models.user_files.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_files/1 or /user_files/1.json
  def destroy
    @user_file.destroy
    redirect_to user_files_url, notice: I18n.t("models.user_files.destroyed")
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
end
