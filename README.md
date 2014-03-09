calendar_reminders
==================

Running the app in development
-----
1. Create the database
    rake db:create
    rake db:schema load

2. Set environment variables (see below)

3. Run a rails server and enjoy!
    rails s

Running the app in production
------

Setting environment variables
-----
Add environment variables that will apply to the server as a whole to /etc/environment:
    RAILS_ENV=production

Good explanation of all environment variables: https://help.ubuntu.com/community/EnvironmentVariables

For application specific environment variables, such as API keys, I took the approach to set the variables from within the application, on application startup.

Specifically, within {Rails.root}/config, I've created a secrets.rb file that will set the environment variables for each rails environment (development, production, test).  The format of the files is, quite simply:

    ENV['setting_key'] = 'value'

You can set the variables to have different values for production, dev, for example, if so desired.  If so, just wrap the different values within the provided case/when statements.

The secrets.rb file has been intentionally left out of source control so as to not expose sensitive data on github.  An example file (config/secrets.example.rb) has been provided.  It can be renamed and the appropriate values can be supplied per environment.

config/environments/secrets.rb is loaded by config/environment.rb on application start.  If the file is not present on your system, the application will still start, but it will soon become apparent that environment variables have not been defined when attempting to access application functionality (such as API calls) that requires them to be set.

In the event that a hosting provider like Heroku is used, this approach can't be used.  Instead, just set the environment variables that the application is using through the 'heroku config' command.

Deploy the application
--------
Capistrano is used to deploy the application to the web server.  The application source contains the Capfile, config/deploy.rb and config/deploy/* files which dictate capistrano's configuration.

cap development deploy

SSH into the server and setup the database
    cd /var/www/apps/calendar-reminders/current

if first time setup:
    rake db:create
    rake db:schema:load 
For DB upgrades/migrations:
      rake db:migrate

(todo) include this in the automated deploy
Copy config/secrets.rb to the server with the following command:
    scp config/secrets.rb ubuntu@webserver:/var/www/apps/calendar-reminders/current/config

Scheduled jobs: cron/whenever
--------
The calendar-reminders application makes use of scheduled jobs run under cron to send out its reminders.  To make things a little bit easier, the application uses the 'whenever' gem for generating the crontab upon deployment to production.

This was fairly straightforward by implementing a job in whenever's DSL within the config/schedule.rb file.  It's important to note, however, that to access elements of the rails application, such as models, the rails environment needs to be preloaded, with the following command:
     Rails.application.eager_load!

Also, it's likely necessary to load the environment as well by requiring 'config/environment.rb'

References: https://github.com/javan/whenever
