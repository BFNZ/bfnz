bfnz
====
SETUP

```
gem install bundler
cd bfnz
sudo apt install postgresql
bundle install
sudo -u postgres -i
createuser bfnz -dP (will prompt for password, enter: secret)
exit
rake db:create
rake db:migrate
rake db:seed
rails s 
```
To connect with pgadmin3, edit pg configuration files, per: https://help.ubuntu.com/community/PostgreSQL and restart pg with:
sudo /etc/init.d/postgresql restart
(not reload as in above docs)

To use preconfigured admin users with email addresses (for testing ONLY, not in prod) add
ENV['RAILS_ENV'] = 'development'
to config/environment.rb
and then run 
rake db:seed to create the 3 test users mentioned at the bottom of db/seeds.rb 
These users can be used to login to the admin site on your local environment
