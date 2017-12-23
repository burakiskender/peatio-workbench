.PHONY: build prepare run test

default: run

build:
	@docker-compose build peatio
	@docker-compose build peatio_daemons
	@docker-compose build peatio_specs

prepare:
	@docker-compose up -d db redis rabbitmq peatio_daemons
	@docker-compose run --rm peatio rake db:create db:migrate

prepare-test: prepare
	@docker-compose up -d selenium
	@docker-compose run --rm peatio_specs rake db:migrate RAILS_ENV=test

run: prepare
	@docker-compose up peatio

test: prepare-test
	@docker-compose run --rm peatio_specs

seed:
	@docker-compose run --rm peatio rake db:seed

down:
	@docker-compose down
