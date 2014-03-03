require 'bundler/capistrano'

set :application, "calendar-reminders"
set :repository,  "git@github.com:wojobucco/calendar_reminders.git"
set :deploy_to, "/var/www/apps/calendar-reminders"

set :scm, :git 

server "ec2-54-85-11-112.compute-1.amazonaws.com", :app, :web, :db, :primary => true

set :user, "ubuntu"
ssh_options[:keys] = ["~/.ssh/amazon_aws.pem"]
ssh_options[:forward_agent] = true

default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
