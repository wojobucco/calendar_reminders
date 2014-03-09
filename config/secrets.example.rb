# this file contains all of the environment variables that need to be set for the application to run
# do not check your secrets into source control!

# set all environment variables that do not change per environment
ENV['BETA_USERS_LIST']=""
ENV['GOOGLE_API_CLIENT_ID']=""
ENV['GOOGLE_API_CLIENT_SECRET']=""
ENV['TWILIO_API_ACCOUNT_SID']=""
ENV['TWILIO_API_AUTH_TOKEN']=""
ENV['TWILIO_API_PHONE_NUMBER']=""

# set environment overrides
case ENV['RAILS_ENV']
  when :production
    # insert values for production
  when :development
    # insert values for development
  when :test
    # insert values for test
end
