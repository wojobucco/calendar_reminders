calendar_reminders
==================
Setup
-----
1. Create the database
    rake db:create
    rake db:schema load

2. Create API configuration files with valid values
  * Twilio
        cp config/twilio_api.yml.sample config/twilio_api.yml
  * Google
        cp config/google_api.yml.sample config/google_api.yml

3. Run a rails server and enjoy!
    rails s
