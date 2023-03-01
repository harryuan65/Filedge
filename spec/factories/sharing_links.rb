FactoryBot.define do
  factory :sharing_link do
    association :user_file
    digest { Digest::SHA256.hexdigest("#{Time.now.to_i}#{Process.pid}#{Thread.current.object_id}#{user_file.id}") }
  end
end
