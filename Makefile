DOCKER=docker-compose -f ./docker/docker-compose.yml
# #todo adapt version and cli/fpm if needed
PHP=php80-cli

build: install

cli:
	$(DOCKER) run $(PHP) bash

coverage:
	$(DOCKER) run --rm $(PHP) php -dxdebug.mode=coverage ./vendor/bin/phpunit --coverage-text

# #todo remove this rule if not needed
down:
	$(DOCKER) down --remove-orphans

fix:
	$(DOCKER) run --rm $(PHP) ./vendor/bin/php-cs-fixer fix

install:
	$(DOCKER) build
	$(DOCKER) run --rm $(PHP) composer install

mutation:
	$(DOCKER) run --rm $(PHP) ./vendor/bin/infection --min-msi=80

phpstan:
	$(DOCKER) run --rm $(PHP) ./vendor/bin/phpstan analyse

psalm:
	$(DOCKER) run --rm $(PHP) ./vendor/bin/psalm --show-info=true

standards:
	$(DOCKER) run --rm $(PHP) ./vendor/bin/php-cs-fixer fix --dry-run -v

test: standards unit phpstan psalm mutation

# #todo remove unused commands in project
unit:
	$(DOCKER) run --rm $(PHP) ./vendor/bin/phpunit
	$(DOCKER) run --rm php81-cli ./vendor/bin/phpunit
	$(DOCKER) run --rm php82-cli ./vendor/bin/phpunit

# #todo remove this rule if not needed
up:
	$(DOCKER) up -d
