
set :application, "rubyonda"
set :domain,      "70.85.16.206"
set :deploy_to,   "/var/rails/#{application}"
set :scm,         "git"
#set :repository,  "git@github.com:brupm/onda.git"
set :repository,   "git://github.com/brupm/onda.git"


set :mongrel_port, 8070
set :mongrel_servers, 1

namespace :vlad do
  desc 'Runs vlad:update, vlad:symlink, vlad:migrate and vlad:start'
  task :deploy => ['vlad:update', 'vlad:symlink', 'vlad:migrate', 'vlad:stop_app', 'vlad:start_app']

  desc 'Symlinks your custom directories'
  remote_task :symlink, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{current_release}/config/database.yml"
    run "ln -s #{shared_path}/private.rb #{current_release}/config/initializers/private.rb"    
  end
end
