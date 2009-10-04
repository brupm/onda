set :application, "napicit.bopia.com"
set :domain,      "bopia"
set :repository,  "git@github.com:brupm/napicit.git"
set :deploy_to,   "/var/rails/#{application}"
set :scm, :git

set :user, "deploy"
set :deploy_via, :remote_cache
set :use_sudo, false

set :git_enable_submodules, 1

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/private.rb #{current_release}/config/initializers/private.rb"        
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared', 'deploy:restart'