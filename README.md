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

====
DOCKER SETUP (Ubuntu)

1. Install docker and docker-compose
2. Add current user to docker group - to run docker without sudo
3. Setup and build images
    ```
    ./install.sh
    ```

4. Start development server
    ```
    docker-compose up
    ```

5. Test all
    ```
    # Headless firefox is used (No visual browser)
    docker-compose -rm -f docker-compose-test.yml run test
    ```

6. Test single file
    ```
    docker-compose -f docker-compose-test.yml run test bundle exec rspec spec/controllers/orders_controller_spec.rb
    ```

7. Run rails commands
    ```
    docker-compose run web bin/rake routes
    docker-compose run web bin/rails console
    ```

8. Clean development / test containers
    ```
    docker-compose down
    docker-compose -f docker-compose-test.yml down
    ```

9. Ports
   ```
   localhost:3000 development server
   localhost:3001 database
   ```
