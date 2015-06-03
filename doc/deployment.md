Deployment
==========

The server apptrack is deployed to will have other rails applications with different Ruby versions. That is we have to prepare to run each application in its own ruby on rails environment.

To prepare the server machine we have to conduct following tasks

* Install Apache 2
* Create the Application Directory
* Install MySQL
* Install Nodejs
* Install RVM
* Install Ruby
* Create a gemset
* Use the gemset
* Install Rails
* Install Passenger
* Configure Apache 2 with Passenger

Install Apache 2
----------------
First check if Apache 2 is installed by invoking

    $ dpkg -s apache2

If it is installed you should see something like

    Package: apache2
    Status: install ok installed
    and a lot more output

To install Apache 2 type in your console

    $ sudo apt-get update
    $ sudo apt-get upgrade
    $ sudo apt-get install apache2

Create the Application Directory
--------------------------------
Per default Apache 2 websites reside in /var/www. We want to deploy apptrack under /var/www/apptrack. To do so we create the directory /var/www/apptrack

    $ sudo /var/www/apptrack
    $ cd /var/www/apptrack
    
Install MySQL
-------------
To check whether MySQL is installed just type `mysql` at the command line. It it is installed you will see the `mysql>` prompt. To exit MySQL just type `quit`

To install MySQL type

    $ sudo apt-get mysql-server

If you don't specify a password for root the default password is root. You should change the password to very secret one.

    $ mysql -u root -p
    mysql> set password for 'root'@'localhost' = password('very_secret');

Create the Database
-------------------
For the production database we use MySQL. We now create a production database.

    $ mysql -u root -p
    mysql> create database apptrack_production default character set utf8;
    mysql> grant all preveleges on apptrack_production.*
        -> to 'pierre@localhost' identified by 'secret_password';
    mysql> exit

Install Nodejs
--------------
To install Nodejs type

    $ sudo apt-get nodejs

Install RVM
-----------
First check if RVM is installed with

    $ rvm -v

If installed it shows the version. On my machine it prints

    rvm 1.26.11 (latest) by Wayne E. Seguine ...

If not installed you can install RVM by

* first adding the mpapis public key

    $ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

* second install RVM

    $ curl -sSL https://get.rvm.io | bash

Install Ruby
------------
Now that we have RVM installed we can install Ruby with RVM

    $ rvm install 2.0.0

Create a Gemset
---------------
As we want to use different Rubies for our different Rails applications we need to manage our Ruby and Rails versions with Gemsets. We name the Gemset after the Rails version.

    $ rvm gemset create rails401

 Use the Gemset
 --------------
 We now select the Gemset that will hold our application. To see which gemsets are available we invoke

    $ rvm list gemsets
    rvm gemsets
    => ruby-2.0.0-p643
       ruby-2.0.0-p643@global
       ruby-2.0.0-p643@rails401

We switch to the rails401 Gemset

    $ rvm ruby-2.0.0-p643@rails401

Install Rails
-------------
Our application is developed with Rails version 4.0.1, that is we will now install Rails version 4.0.1 in our Gemset ruby-2.0.0-p643@rails401.

    $ gem install rails --version 4.0.1 --no-ri --no-rdoc    

Install Passenger
-----------------
Now we do the final preparation step on our server machine. We install Phusion Passenger

    $ gem install passenger
    $ passenger-install-apache2-module

Passenger will tell you if it needs additonal libraries which it depends on. If so just follow the instructions Passenger is telling you and then invoke `passenger-install-apache2-module` again.

After passenger is done it will provide a code sequence to add to the apache2 configuration file.

```
   LoadModule passenger_module /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/gems/passenger-5.0.8/buildout/apache2/mod_passenger.so
   <IfModule mod_passenger.c>
     PassengerRoot /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/gems/passenger-5.0.8
     PassengerDefaultRuby /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/wrappers/ruby
   </IfModule>
```

Configure Apache 2 with Passenger
---------------------------------
After installation Passenger was telling us to insert snippets to the apache2.conf file and to create a virtual host for our application.

###apache2.conf
We have add some code to apache2.conf in order to start up passenger. We could add the code directly to apache2.conf but we would like rather to separate the configuration in a separate file. Apache2 has the notion of importing configuration code from /etc/apache2/conf-enabled/ directory. We first put the below code in /etc/apache2/conf-available/passenger.conf

```
   LoadModule passenger_module /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/gems/passenger-5.0.8/buildout/apache2/mod_passenger.so
   <IfModule mod_passenger.c>
     PassengerRoot /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/gems/passenger-5.0.8
     PassengerDefaultRuby /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/wrappers/ruby
   </IfModule>
```

Then we invoke a2enconf passenger.conf to mark the passenger.conf as enabled.

###Configure a virtual host for apptrack
Now we configure Apache2 to find our application and create a virtual host in /etc/apache2/sites-available/apptrack.conf

```
   <VirtualHost *:80>
      ServerName apptrack
      DocumentRoot /var/www/apptrack/current/public    
      PassengerRuby  /home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401/wrappers/ruby
      <Directory /var/www/apptrack/public>
         # This relaxes Apache security settings.
         AllowOverride all
         # MultiViews must be turned off.
         Options -MultiViews
         # Uncomment this if you're on Apache >= 2.4:
         Require all granted
         # apptrack is using the Ruby version in the gemset
      </Directory>
   </VirtualHost>
```
In the above code we add `PassengerRuby` to indicate when launching apptrack we want to use the ruby in the `ruby-2.0.0-p643@rails401` gemset. If we have another application we can launch it with a different Ruby version.

Now we restart Apache 2 with `sudo apachectl restart`. As we don't have the application deployed yet, we will see an error message from Apache 2 which we happily read as it indicates that our virtual host is recognized by Apache 2.

    $ sudo apachectl restart
    AH00112: Warning: DocumentRoot [/var/www/apptrack/current/public] does not exist

Next we will prepare our client machine for deployment.

Prepare the client machine for deployment
-----------------------------------------
In order to deploy our application we need to add some gems, namely mysql and capistrano. We will use MySQL database for our production application and Capistrano is used for deploying our application from the client machine to the production machine.

###Add the MySQL Gem
In the Gemfile we add the MySQL gem into the production group

    gem 'mysql2', group: :production

###Add the Capistrano Gem
To deploy our application from the client to the server we add the Capistrano gem into the development group in our Gemfile

    group :development do
      gem 'capistrano'
      gem 'capistrano-bundler'
      gem 'capistrano-rails'
    end

###Install the required Gems
To install the gems capistrano and mysql2 we run bundle install

    $ bundle install
    
###Change the production database to MySQL 2
Change the production block in config/database.yml to

    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: apptrack_production
      pool: 5
      username: user
      password: password
      host: localhost

and add config/database.yml to your .gitignore file otherwise your database credentials will be publicaly available.

###Setup Captistrano
To set up Capistrano we have to follow these steps

* Create the configuration files `capify .`
* Assign a host name to the IP address of our deployment machine in /etc/hosts
* Configure config/deploy.rb
* Configure config/deploy/production.rb

####Create the configuration files
To create the configuration files we issue

    $ capify .

This will create the Capfile, config/deploy.rb and config/deploy/production.rb

####Assign a host name to the IP address of our deployment machine
We have to tell Capistrano where to deploy our application to. This we do in the config/deploy/production.rb. We could add the IP-address of our deployment machine but we also could map a host name to the IP-address, which is more readable. To do so we put the mapping into /etc/hosts

    192.168.178.61 apptrack.uranus

###Create a private key without password
When we want to deploy our application Capistrano will ssh to our application server. To avoid entering the password during ssh we want to create a private key without password.

    $ cd ~/.ssh
    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/pierre/.ssh/id_rsa): deploy
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in deploy.
    Your public key has been saved in deploy.rb

When asked for a passphrase just enter return to ommit the passphrase.

Now copy your public key to your application server to your account.

    $ scp ~/.ssh/deploy.pub me@applicationserver:key

ssh to your application server
 
    $ ssh me@applicationserver

On your server add the public key to authorized keys

    $ cat key >> ~/.ssh/authorized_keys

Log out from your server and log in again. Now you should not need to enter a password.

This is not neccessarily the most secure option.

####Add a key to pull from github
When deploying Capistrano will fetch our application from Github. In order to do so we will need a key so Github allows access to download the application. The easy way is to copy the key from our deployment machine, which should already have a key for Github or we can create another key on the server and then make it available to Github. In eather way we have to start ssh-agent so we don't have to provide the password.

First we need to start ssh-agent

    $ eval $(ssh-agent)

Then we issue ssh-add which will add the default key to the ssh-agent after we provide the password for the key.

    $ ssh-add

####Configura config/deploy/production.rb
We add following lines to config/deploy/production.rb so Capistrano knows where to deploy the application to

set :domain, 'apptrack.uranus'

role :app, [domain]
role :web, [domain]
role :db,  [localhost], primary: :true

server domain,
       user: 'deployer',
       group: 'deployers',
       roles: %w{web app db},
       ssh_options: {
         user: 'deployer',
         keys: %w(~/.ssh/id_rsa),
         forward_agent: true
       }

####Configure config/deploy.rb
Add following to config/deploy.rb

    set: :application 'apptrack'
    set: :repo_url, 'git@github.com:sugaryourcoffee/apptrack.git'
    set: :branch, 'master'

    set: :deploy_to, '/var/www/apptrack'
    set: :scm, :git

    set: :key_releases, 5

    namespace :deploy do

      desc 'Restart application'
      task: :restart do
        on roles(:app), in: :sequence, wait: 5 do
          execute :touch, release_path.join('tmp/restart.txt')
        end
      end

      desc 'Copy database.yml file into the latest release'
      task :copy_database_yml do
        on roles(:app) do
          execute :cp, shared_path.join('confit/database.yml'),
                       release_path.join('config/')
        end
      end

      after :restart, :clear_cache do
        on roles(:web), in: :groups, limit: 3, wait: 10 do
          within release_path do
            execute :rake, 'tmp:clear'
          end
        end
      end

      before :updated, 'deploy:copy_database_yml'
      after :finishing, 'deploy:cleanup'
    end

####Make deployment directory writeable by the deployment user
We want to deploy to /var/www/apptrack. But this directory is owned by root. In order to deploy with our deployment user we have to change the group owning the deployment directory to the group of the deployment user.

    $ sudo chgrp deployers /var/www

In order to give the deployers write access to /var/www we issue

    $ sudo chmod g+w /var/www

####Deploy the application
Now we are good to go for deployment

    $ cap production deploy
