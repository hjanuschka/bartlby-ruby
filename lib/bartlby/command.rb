require 'commander'

module Bartlby
  class Command
    include Commander::Methods
    def run
      program :name, 'Bartlby'
      program :version, '0.0.1'
      program :description, 'Bartlby System Monitor'

      command :run do |c|
        c.syntax = 'bartlby run'
        c.description = 'runs bartlby'
        c.option '--config STRING', String, 'Path to config file'
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
