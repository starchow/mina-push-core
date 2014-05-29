# # Modules: PushCore
# Adds settings and tasks for managing PushCore workers.
#
# ## Usage example
#     require 'mina_push_core/tasks'
#     ...
#     task :setup do
#       # push_core needs a place to store its pid file
#       queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
#     end
#
#     task :deploy do
#       deploy do
#         invoke :'push_core:quiet'
#         invoke :'git:clone'
#         ...
#
#         to :launch do
#           ...
#           invoke :'push_core:restart'
#         end
#       end
#     end

require 'mina/bundler'
require 'mina/rails'

# ## Settings
# Any and all of these settings can be overriden in your `deploy.rb`.

# ### push_core
# Sets the path to push_core.
set_default :push_core, lambda { "#{bundle_bin} exec push" }

# ### push_core_log
# Sets the path to the log file of push_core
#
# To disable logging set it to "/dev/null"
set_default :push_core_log, lambda { "#{deploy_to}/#{current_path}/log/push_core.log" }

# ### push_core_pid
# Sets the path to the pid file of a push_core worker
set_default :push_core_pid, lambda { "#{deploy_to}/#{shared_path}/pids/push_core.pid" }

# ### push_core_processes
# Sets the number of push_core processes launched
set_default :push_core_processes, 1

# ## Control Tasks
namespace :push_core do
  def for_each_process(&block)
    push_core_processes.times do |idx|
      pid_file = if idx == 0
                   push_core_pid
                 else
                   "#{push_core_pid}-#{idx}"
                 end
      yield(pid_file, idx)
    end
  end

  # ### push_core:stop
  desc "Stop push_core"
  task :stop => :environment do
    queue %[echo "-----> Stop push_core"]
    for_each_process do |pid_file, idx|
      queue %[
        if [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1
        then 
          kill -SIGINT `cat #{pid_file}`
        else 
          echo 'push daemon is not running'
        fi
      ]
    end
  end

  # ### push_core:start
  desc "Start push_core"
  task :start => :environment do
    queue %[echo "-----> Start push_core"]
    for_each_process do |pid_file, idx|
      queue %{
        cd "#{deploy_to}/#{current_path}"
        nohup bundle exec push #{rails_env} -p #{pid_file} >> #{push_core_log} 2>&1 &
      }
    end
  end

  # ### push_core:restart
  desc "Restart push_core"
  task :restart do
    invoke :'push_core:stop'
    invoke :'push_core:start'
  end
end
