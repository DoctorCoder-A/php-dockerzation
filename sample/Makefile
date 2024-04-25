init: docker-down-clean docker-build docker-up app-init
start: docker-down-clean docker-up
down: docker-down-clean
up: docker-up
stop: docker-stop
test-docker: docker_resolve

env := ./.env.docker
ifneq (,$(wildcard ${env}))
    include .env.docker
    export
endif

docker_composer := docker compose  --env-file .env.docker -p ${PROJECT_NAME}

docker_resolve:
	${docker_composer} config
docker-build:
	${docker_composer} build
docker-up:
	${docker_composer} up -d
docker-down-clean:
	${docker_composer} down -v --remove-orphans
docker-stop:
	${docker_composer} stop

app-init: composer-update artisan-key-generate artisan-storage-link migrate-seed

composer-update:
	${docker_composer} exec app composer update
artisan-key-generate:
	${docker_composer} exec app php artisan key:generate
migrate-seed:
	${docker_composer} exec app php artisan migrate:fresh --seed
route-list:
	${docker_composer} exec app php artisan route:list > routes.txt
artisan-storage-link:
	([ -L "public/storage" ] && rm -r public/storage) && ([ -d "storage/app/public" ] || mkdir storage/app/public) && ${docker_composer} exec app php artisan storage:link
bash:
	${docker_composer} exec app bash
full-cache:
	${docker_composer} exec app php artisan optimize:clear
migrate:
	${docker_composer} exec app php artisan migrate
tinker:
	${docker_composer} exec app php artisan tinker
