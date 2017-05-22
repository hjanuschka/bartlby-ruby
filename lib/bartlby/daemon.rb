module Bartlby
  class Daemon
    attr_accessor :threads
    def initialize(options)
      puts "INIT options: #{options.inspect}"
    end
    def start!
      @threads ||= []

      # Start Scheduler
      @threads << Thread.new do
        Bartlby.Scheduler.run!
      end

      # Start Worker
      @threads << Thread.new do
        Bartlby.Worker.run!
      end

      # Wait for all threads to finish
      @threads.each(&:join)
    end
  end
end
