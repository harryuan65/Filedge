user = User.find_by(email: "admin@gmail.com")
unless user
  user.password = "111111"
  user.save!
end
