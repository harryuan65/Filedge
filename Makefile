.PHONY: setup dev
setup: # Build images and setup databases
	@echo "\033[44m[App] Building images...\033[0m"
	docker compose build --no-cache
	@echo "\033[44m[App] Setting up databases...\033[0m"
	docker compose run --rm web bin/rails db:create db:migrate db:seed
	@echo "\033[42m[App] Build Completed! Run \"make dev\" to start the services.\033[0m"
reset: # Recreate containers and setup database
	@echo "\033[44m[App] Resetting services...\033[0m"
	docker compose down
	@echo "\033[44m[App] Setting up databases...\033[0m"
	docker compose run --rm web bin/rails db:create db:migrate db:seed
	@echo "\033[42m[App] Services have been successfully reset. Run \"make dev\" to start the services.\033[0m"
dev:
	@echo "\033[44m[App] Starting compose services...\033[0m"
	docker compose up
