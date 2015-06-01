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
In order to deploy our application we need to do add some gems, namely mysql and capistrano. We will use MySQL database for our production application and the Capistrano is used for deploying our application from the client machine to the production machine.

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