user = User.find_by!(email: "admin@gmail.com")
unless user.files.exists?(asset: "seed_file.txt")
  user.files.create!(asset: Rails.root.join("db/seeds/seed_file.txt").open("r"))
end
