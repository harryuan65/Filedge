# == Schema Information
#
# Table name: sharing_links
#
#  digest       :string           not null, primary key
#  user_file_id :uuid             not null
#  expire_at    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
#
# Sharing link to a user file
#
class SharingLink < ApplicationRecord
  belongs_to :user_file

  def expired?
    expire_at < Time.zone.now
  end
end
