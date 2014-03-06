require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :stages, %w(development production)

set :application, "calendar-reminders"
set :repository,  "git@github.com:wojobucco/calendar_reminders.git"
set :deploy_to, "/var/www/apps/calendar-reminders"

set :scm, :git 

ssh_options[:forward_agent] = true
set :user, "ubuntu"

set :rails_env, 'production'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
