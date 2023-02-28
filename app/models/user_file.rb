#
# User can upload file.
#
class UserFile < ApplicationRecord
  belongs_to :user
  belongs_to :sharing_link
  mount_uploader :asset, UserFileUploader
end
