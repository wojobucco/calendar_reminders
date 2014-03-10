# Calendar Reminders
An appointment management and reminding application developed on the Ruby on Rails web framework.

## Running the app in development
1. Create the database

        rake db:create
        rake db:schema load

2. Set environment variables in config/secrets.rb ([see below](#app_env_variables))

3. Start the development rails server:

        rails s

4. Navigate to http://lvh.me:3000.

5. Enjoy!

## Running the app in production

This guide is written for a traditional web server setup, and not a cloud platform like Heroku.
The configuration which this was tested upon is as follows:

* Ubuntu Server 12.04.4 LTS
* Phusion Passenger 4.0.37
* Apache 2.2.22
* MySQL 5.5.35

### Setting environment variables

#### System-wide environment variables
Add environment variables that will apply to the server as a whole to /etc/environment. 
For instance:

    RAILS_ENV=production

A good explanation of environment variables on Ubuntu can be found at: https://help.ubuntu.com/community/EnvironmentVariables

#### Application specific environment variables <a name="app_env_variables"></a>
For application specific environment variables, such as API keys (Google, Twilio, etc.), I took the approach to set the variables 
from within the application, on application startup.

Within {Rails.root}/config, there exists a secrets.rb file that will set the environment variables 
for each rails environment (development, production, test).  The format of the files is, quite simply:

    ENV['setting_key_1'] = 'value'
    ENV['setting_key_2'] = 'value'

You can set the variables to have different values for production, devevelopment and test, if so desired.  
If so, just wrap the different values within the provided case/when statements.

The secrets.rb file has been intentionally left out of source control so as to not expose sensitive data on github.  
An example file (config/secrets.example.rb) has been provided.  It can be renamed and the 
appropriate values can be supplied per environment.

config/environments/secrets.rb is loaded by config/environment.rb on application start.  If the file is not is
present on your system, the application will still start, but it will soon become apparent that environment variables 
have not been defined when attempting to access application functionality (such as API calls) that requires them to be set.

In the event that a hosting provider like Heroku is used, this approach can't be used.  Instead, just set 
the environment variables that the application is using through the 'heroku config' command. You can get
the definitive list of environment variables from config/app_config.yml.

### Deployment
Capistrano is used to deploy the application to a web server.  The application source contains the Capfile, 
config/deploy.rb and "config/deploy/." files which dictate capistrano's configuration. You will need
to customize these files with values that are applicable to your production server setup.

Deploy the application

    cap production deploy

SSH into the server and setup the database

    cd /var/www/apps/calendar-reminders/current

* If this is a first time setup:

        rake db:create
        rake db:schema:load 

* For DB upgrades/migrations:

        rake db:migrate

(todo) include this in the automated deploy
Copy config/secrets.rb to the server with the following command:

    scp config/secrets.rb ubuntu@webserver:/var/www/apps/calendar-reminders/current/config

### Scheduled jobs: cron/whenever
The calendar-reminders application makes use of scheduled jobs run under cron to send out its reminders.  
To make things a little bit easier, the application uses the 'whenever' gem for generating the crontab upon deployment to production.

This was fairly straightforward by implementing a job in whenever's DSL within the config/schedule.rb file.  
It's important to note, however, that to access elements of the rails application, such as models, the rails 
environment needs to be preloaded, with the following command:

     Rails.application.eager_load!

Also, it's necessary to load the environment as well by requiring 'config/environment.rb'

These things have already been done in the production:send_reminders rake task.  But it'll need to be done
again for any other similar jobs that end up getting added.

References: https://github.com/javan/whenever
