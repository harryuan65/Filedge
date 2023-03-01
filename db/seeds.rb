Dir[Rails.root.join("db/seeds/*.rb")].each do |file_path|
  require file_path
end
