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

set :keep_releases, 3

before "deploy:restart", "deploy:upload_secrets"
after "deploy:update_code", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :upload_secrets do
    top.upload(File.expand_path('../secrets.rb', __FILE__), File.join(current_path, 'config','secrets.rb'), 
      {:via => :scp, :mode => '644', :keys => ssh_options[:keys] })
  end
end
