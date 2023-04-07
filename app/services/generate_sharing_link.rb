# frozen_string_literal: true

#
# Generate a sharing link for file
#
class GenerateSharingLink
  def initialize(user_file, new_expire_at = 30.days.from_now)
    @file_id = user_file.id
    @new_expire_at = new_expire_at
  end

  # @return [SharingLink]
  def call
    if (link = SharingLink.find_by(user_file_id: @file_id))
      link.update!(expire_at: @new_expire_at) if link.expired? # Renewal
      link
    else
      SharingLink.create!(
        user_file_id: @file_id,
        expire_at: @new_expire_at,
        digest: Digest::SHA256.hexdigest(@file_id)
      )
    end
  end

  def self.call(*args)
    new(*args).call
  end
end
