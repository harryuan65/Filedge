user = User.find_or_initialize_by(email: "admin@gmail.com")
user.password = "111111"
user.save!
