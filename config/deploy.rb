require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'whenever/capistrano'

set :stages, %w(development production)

set :application, "calendar-reminders"
set :repository,  "git@github.com:wojobucco/calendar_reminders.git"
set :deploy_to, "/var/www/apps/calendar-reminders"

set :scm, :git 

ssh_options[:forward_agent] = true
set :user, "ubuntu"

set :rails_env, 'production'

set :whenever_command, "bundle exec whenever"

before "deploy:restart", "deploy:upload_secrets"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :upload_secrets do
    #upload('config/secret.rb', File.join(deploy_to, 'config','secret.rb'), {:via => :scp, :mode => '644' })
  end
end