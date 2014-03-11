server "ec2-54-85-91-99.compute-1.amazonaws.com", :app, :web, :db, :primary => true

ssh_options[:keys] = ["~/.ssh/amazon_aws.pem"]
