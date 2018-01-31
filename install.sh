#!/bin/bash

# export UID and GID to run docker with the same user as the local user
if [[ -z $(cat ~/.bashrc | grep 'export GID') ]]
then
  printf "\033[0;32mUpdating ~/.bashrc (export UID and GID)\033[0m\n"
  printf "export UID\nexport GID=$(id -g)\n" >> ~/.bashrc
fi

printf "\033[0;32mBuild images\033[0m\n"
docker-compose build
docker-compose -f docker-compose-test.yml build
