task setup: %i[build setup_db] do
  puts "\e[42m[App] Build Completed! Run \"bin/rails up\" to start the services.\e[0m"
end

task reset: %i[remove_containers setup_db] do
  desc "Recreate containers and setup database"
  puts "\e[42m[App] Services have been successfully reset. Run \"bin/rails up\" to start the services.\e[0m"
end

task :build do
  desc "Build images"
  puts "\e[44m[App] Building images...\e[0m"
  system "docker compose build --no-cache"
end

task :setup_db do
  desc "Setup databases"
  puts "\e[44m[App] Setting up databases...\e[0m"
  system "docker compose run --rm web bin/rails db:create db:migrate db:seed"
end

task :remove_containers do
  desc "Remove containers"
  puts "\e[43m[App] Removing containers...\e[0m"
  system "docker compose down"
end

task :up do
  desc "Docker compose up"
  puts "\e[44m[App] Starting compose services...\e[0m"
  system "docker compose up"
end

task :down do
  desc "Docker compose down"
  puts "\e[41m[App] Removing compose services...\e[0m"
  system "docker compose down"
end
