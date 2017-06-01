require "bunny"
module Bartlby
  CONFIG = Bartlby::Config
  class Daemon
    attr_accessor :threads
    def initialize(options)
      @options = options
    end

    def load_config
      CONFIG.config =  YAML.load_file(File.expand_path(@options.config))
    end

    def start!
      load_config
      @threads ||= []

      CONFIG.db = Object.const_get(CONFIG.config["system"]["db"]).new
      CONFIG.queue = Object.const_get(CONFIG.config["system"]["queue"]).new

      # Start Scheduler
      @threads << Thread.new do
        Bartlby::Scheduler.new.run!
      end

      # Start Worker
      @threads << Thread.new do
        Bartlby::Worker.new.run!
      end

      # Wait for all threads to finish
      @threads.each(&:join)

      cleanup
    end

    def cleanup
      @bunny[:conn].close
    end
  end
end
