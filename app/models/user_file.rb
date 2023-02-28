#
# User can upload file.
#
class UserFile < ApplicationRecord
  belongs_to :user
end
