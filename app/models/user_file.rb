# == Schema Information
#
# Table name: user_files
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  asset      :string           not null
#  file_size  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
# User can upload file.
#
class UserFile < ApplicationRecord
  belongs_to :user
  has_one :sharing_link, dependent: :destroy
  mount_uploader :asset, UserFileUploader

  validates :asset, presence: true

  before_save :set_file_size

  def set_file_size
    self.file_size = asset.size
  end
end
