#
# User can upload file.
#
class UserFile < ApplicationRecord
  belongs_to :user
  belongs_to :sharing_link, optional: true
  mount_uploader :asset, UserFileUploader

  after_create :set_file_size

  def set_file_size
    self.file_size = asset.size
  end
end
