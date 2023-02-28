#
# Responsible for user files CRUD operations
#
class UserFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_file, only: %i[show edit update destroy]

  # GET /user_files or /user_files.json
  def index
    @user_files = current_user.files.all
  end

  # GET /user_files/1 or /user_files/1.json
  def show
  end

  # GET /user_files/new
  def new
    @user_file = current_user.files.new
  end

  # GET /user_files/1/edit
  def edit
  end

  # POST /user_files or /user_files.json
  def create
    @user_file = current_user.files.new(asset: user_file_params[:asset])

    if @user_file.save
      redirect_to user_file_url(@user_file), notice: "User file was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_files/1 or /user_files/1.json
  def update
    if @user_file.update(user_file_params)
      redirect_to user_file_url(@user_file), notice: "User file was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_files/1 or /user_files/1.json
  def destroy
    @user_file.destroy
    redirect_to user_files_url, notice: "User file was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_file
    @user_file = UserFile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_file_params
    params.fetch(:user_file, {})
  end
end
