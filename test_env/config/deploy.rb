require 'mina'
require 'mina/git'
require 'mina_push_core/tasks'
require 'mina/git'
require 'mina/bundler'
require 'mina/rvm'
require 'fileutils'

FileUtils.mkdir_p "#{Dir.pwd}/deploy"

set :ssh_options, '-o StrictHostKeyChecking=no'

set :domain, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :repository, 'https://github.com/starchow/mina-push-core-test-rails.git'
set :keep_releases, 2
set :push_core_processes, 2

set :shared_paths, ['log']

task :environment do
  invoke :'rvm:use[ruby-2.0.0]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[mkdir -p "#{deploy_to}/shared/log/"]
end

task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'

    to :launch do
      invoke :'push_core:start'
      queue! %[sleep 3; kill -0 `cat #{push_core_pid}`]

      invoke :'push_core:quiet'

      invoke :'push_core:stop'
      queue! %[(kill -0 `cat #{push_core_pid}`) 2> /dev/null && exit 1 || exit 0]
    end
  end
end
