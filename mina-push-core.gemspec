# -*- encoding: utf-8 -*-

require "./lib/mina_push_core/version.rb"

Gem::Specification.new do |s|
  s.name = "mina-push-core"
  s.version = MinaPushCore.version
  s.authors = ["Star Chow"]
  s.email = ["puma.puma07@gmail.com"]
  s.homepage = "http://github.com/starchow/mina-push-core"
  s.summary = "Tasks to deploy PushCore with mina."
  s.description = "Adds tasks to aid in the deployment of PushCore"
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.post_install_message = <<-MESSAGE
  Starting with 0.1.0, you have to add:

      require 'mina_push_core/tasks'

  in your deploy.rb to load the library
  MESSAGE

  s.add_runtime_dependency "mina"
end
