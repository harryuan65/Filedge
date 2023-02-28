#
# User can upload file.
#
class UserFile < ApplicationRecord
  belongs_to :user
  mount_uploader :asset, UserFileUploader
end
