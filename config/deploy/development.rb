server "webserver", :app, :web, :db, :primary => true
default_run_options[:pty] = true
ssh_options[:keys] = ["~/.ssh/id_rsa"]
