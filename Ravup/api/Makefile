build: install migrations fixture re

re:
	rm -rf ./public/uploads/*

install:
	@echo "Launch composer install ..."
	@composer install

migrations:
	@echo "Launch migrations ..."
	@php bin/console doctrine:migrations:migrate

fixture:
	@echo "Setup fixtures ..."
	@php bin/console hautelook:fixtures:load --purge-with-truncate
