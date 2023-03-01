#
# Sharing link to a user file
#
class SharingLink < ApplicationRecord
  belongs_to :user_file
  before_create :generate_digest

  def generate_digest
    self.digest = Digest::SHA256.hexdigest("#{Time.now.to_i}#{Process.pid}#{Thread.current.object_id}#{user_file_id}")
  end

  def expired?
    expire_at < Time.zone.now
  end
end
