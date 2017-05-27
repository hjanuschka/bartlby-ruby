require 'commander'

module Bartlby
  class Worker
    def initialize(queue: nil, db: nill)
      @db = db
      @queue = queue
      @shutdown = false
    end

    def run!
      until @shutdown
        @queue.pull do |message|
          puts "GOT Message #{message.inspect}"
        end
      end
    end
  end
end
