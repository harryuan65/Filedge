#
# User can upload file.
#
class UserFile < ApplicationRecord
  belongs_to :user
  has_one :sharing_link, dependent: :destroy
  mount_uploader :asset, UserFileUploader

  after_create :set_file_size

  def set_file_size
    self.file_size = asset.size
  end
end
