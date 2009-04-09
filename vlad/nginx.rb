require 'vlad'

namespace :vlad do
  ##
  # Nginx web server

  set :web_command, "sudo /etc/init.d/nginx"

  desc "(Re)Start the nginx web servers"

  remote_task :start_web, :roles => :web  do
    run "#{web_command} start"
  end

  desc "Stop the nginx web servers"

  remote_task :stop_web, :roles => :web  do
    run "#{web_command} stop"
  end

  desc "(Re)Start the nginx web and app servers"

  remote_task :start do
    Rake::Task['vlad:start_app'].invoke
    Rake::Task['vlad:start_web'].invoke
  end



  desc "Stop the nginx web and app servers"

  remote_task :stop do
    Rake::Task['vlad:stop_app'].invoke
    Rake::Task['vlad:stop_web'].invoke
  end
end