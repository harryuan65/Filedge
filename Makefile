.PHONY: setup dev
setup:
	@echo "\033[44m[App] Building images...\033[0m"
	docker compose build
	@echo "\033[44m[App] Setting up databases...\033[0m"
	docker compose run --rm web bin/rails db:create db:migrate db:seed
	@echo "\033[42m[App] Build Completed! Run \"make dev\" to start the services.\033[0m"
dev:
	@echo "\033[44m[App] Starting compose services...\033[0m"
	docker compose up
