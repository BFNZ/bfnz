bfnz
====
SETUP

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
To connect with pgadmin3, edit pg configuration files, per: https://help.ubuntu.com/community/PostgreSQL and restart pg with:
sudo /etc/init.d/postgresql restart
(not reload as in above docs)
