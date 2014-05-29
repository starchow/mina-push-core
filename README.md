mina-push-core
============

mina-push-core is a gem that adds tasks to aid in the deployment of [Push-Core] (http://github.com/tompesman/push-core)
using [Mina] (http://nadarei.co/mina).
This gem was created base on [mina-sidekiq] (http://github.com/Mic92/mina-sidekiq)!


# Getting Start

## Installation

    gem install mina-push-core

## Example

## Usage example

    require 'mina_push_core/tasks'
    ...
    # to make logs persistent between deploys
    set :shared_paths, ['log']

    task :setup do
      # push core needs a place to store its pid file and log file
      queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
      queue! %[mkdir -p "#{deploy_to}/shared/log/"]
    end

    task :deploy do
      deploy do
        # stop accepting new workers
        invoke :'git:clone'
        invoke :'deploy:link_shared_paths'
        ...

        to :launch do
          ...
          invoke :'push_core:restart'
        end
      end
    end

## Available Tasks

* push_core:stop
* push_core:start
* push_core:restart

## Available Options

| Option              | Description                                                                    |
| ------------------- | ------------------------------------------------------------------------------ |
| *push_core*           | Sets the path to push_core.                                                      |
| *push_core\_log*      | Sets the path to the log file of push_core.                                      |
| *push_core\_pid*      | Sets the path to the pid file of a push_core worker.                             |
| *push_core_processes* | Sets the number of push_core processes launched.                                 |

## Testing

The test requires a local running ssh server with the ssh keys of the current
user added to its `~/.ssh/authorized_keys`. In OS X, this is "Remote Login"
under the Sharing pref pane.

To run the full blown test suite use:

    bundle exec rake test

For faster release cycle use

    cd test_env
    bundle exec mina deploy --verbose

## Copyright

Copyright (c) 2013 Star Chow http://phamtrungnam.info

See LICENSE for further details.
