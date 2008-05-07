
set :application, "rubyonda"
set :domain,      "70.85.16.206"
set :deploy_to,   "/var/rails/#{application}"
set :repository,  "git@github.com:brupm/onda.git"

set :mongrel_port, 8070
set :mongrel_servers, 3

namespace :vlad do
  desc 'Runs vlad:update, vlad:symlink, vlad:migrate and vlad:start'
  task :deploy => ['vlad:update', 'vlad:symlink', 'vlad:migrate', 'vlad:stop_app', 'vlad:start_app']

  desc 'Symlinks your custom directories'
  remote_task :symlink, :roles => :app do
    run "ln -s #{shared_path}/assets #{latest_release}/public/assets" 
  end

  #desc 'Setup your custom directories in shared.'
  #remote_task :setup_shared, :roles => :app do
  #  dirs = %w(assets).map { |d| File.join(shared_path, d) }
  #  run "umask 02 && mkdir -p #{dirs.join(' ')}" 
  #end

  # Run our setup_shared task during setup
  #task :setup do
  #  Rake::Task['vlad:setup_shared'].invoke
  #end
end