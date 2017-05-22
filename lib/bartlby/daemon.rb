require "bunny"
module Bartlby
  class Daemon
    attr_accessor :threads
    def initialize(options)
      puts "INIT options: #{options.inspect}"
    end
    def start!

      # Connect to MQ
      @bunny = {
            conn: Bunny.new(:hostname => "localhost"),
      }
      @bunny[:conn].start
      @bunny[:ch] = @bunny[:conn].create_channel
      @bunny[:queue] = @bunny[:ch].queue("BARTLBY")



      @threads ||= []

      # Start Scheduler
      @threads << Thread.new do
        Bartlby::Scheduler.new(bunny: @bunny).run!
      end

      # Start Worker
      @threads << Thread.new do
        Bartlby::Worker.new(bunny: @bunny).run!
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
