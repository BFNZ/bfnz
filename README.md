bfnz
====
SETUP

```
# Install rbenv https://github.com/rbenv/rbenv#installation
# Install docker https://docs.docker.com/get-docker/
cd bfnz
rbenv install
gem install bundler
docker compose up -d
bundle install
rails db:create
rails db:migrate
rails db:seed
rails s
```
