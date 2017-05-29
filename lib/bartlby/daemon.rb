require "bunny"
module Bartlby
  class Daemon
    attr_accessor :threads
    def initialize(options)
      @options = options
    end

    def load_config
      @configuration = YAML.load_file(File.expand_path(@options.config))
    end

    def start!
      load_config
      @threads ||= []

      @db = Object.const_get(@configuration["system"]["db"]).new(configuration: @configuration)

      @queue = Object.const_get(@configuration["system"]["queue"]).new(configuration: @configuration)

      # Start Scheduler
      @threads << Thread.new do
        Bartlby::Scheduler.new(db: @db, queue: @queue).run!
      end

      # Start Worker
      @threads << Thread.new do
        Bartlby::Worker.new(db: @db, queue: @queue).run!
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
