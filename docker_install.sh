#!/bin/bash

# export USER_ID and GROUP_ID to run docker with the same user as the local user
printf "\033[0;32mUpdating .env (adding USER_ID and GROUP_ID)\033[0m\n"
printf "USER_ID=$(id -u)\nGROUP_ID=$(id -g)\n" > ./.env

# printf "\033[0;32mBuild images\033[0m\n"
docker-compose build
docker-compose run --rm app gem install bundler -v 1.16.3
docker-compose run --rm app bundle install
docker-compose run --rm app bin/rake db:migrate
docker-compose run --rm app bin/rake db:seed
docker-compose run --rm app bin/rake db:test:prepare
