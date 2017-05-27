require "bunny"
module Bartlby
  class Daemon
    attr_accessor :threads
    def initialize(options)
      puts "INIT options: #{options.inspect}"
    end

    def start!
      @threads ||= []
      # FIXME: load correct DB layer
      @db = Bartlby::DbYaml.new

      # FIXME: load correct Queue Layer
      @queue = Bartlby::NativeQueue.new

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
