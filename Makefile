dirSample:=~/projects/scripts/dockerzation/sample
init: copy-dir-configurations copy-compose-configurations copy-tmp-configurations set_project_name success-message
env := .env.docker

copy-dir-configurations:
	@echo `cp -r ${dirSample}/docker ${PWD}/docker`
copy-compose-configurations:
	@echo `cp ${dirSample}/docker-compose.yml ${PWD}/docker-compose.yml`
copy-tmp-configurations:
	@echo `cp ${dirSample}/.env ${PWD}/${env}`
	@echo `cp ${dirSample}/Makefile ${PWD}/Makefile`
set_project_name:
	@read -p "Enter project name  must consist only of lowercase alphanumeric characters, hyphens, and underscores as well as start with a letter or number:" PROJECT_NAME; \
	echo PROJECT_NAME=$$PROJECT_NAME >> ${PWD}/${env}.new; \
	cat ${PWD}/${env} >> ${PWD}/${env}.new; \
	mv ${PWD}/${env}.new ${PWD}/${env}
success-message:
	@echo success
test:
	@echo `ls ${dirSample}`
