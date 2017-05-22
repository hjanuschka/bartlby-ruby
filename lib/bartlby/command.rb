require 'commander'

module Bartlby
  class Command
    include Commander::Methods
    def run
      program :name, 'Foo Bar'
      program :version, '1.0.0'
      program :description, 'Stupid command that prints foo or bar.'

      command :run do |c|
        c.syntax = 'foobar foo'
        c.description = 'Displays foo'
        c.action do |args, options|
          # Start it
          Bartlby::Daemon.new(options).start!
        end
        default_command :run
        run!
      end
    end
  end
end
