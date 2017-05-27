require 'commander'

module Bartlby
  class Scheduler
    def initialize(queue: nil, db: nill)
      @db = db
      @queue = queue
    end

    def run!
      loop do
        puts "SCHEDULER"
        @queue.post("Some New Message")
        sleep 10
      end
    end
  end
end
