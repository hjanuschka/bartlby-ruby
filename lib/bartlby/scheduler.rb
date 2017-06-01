require 'commander'

module Bartlby
  class Scheduler
    def run!
      loop do
        puts "SCHEDULER"
        CONFIG.queue.post("Some New Message")
        sleep 10
      end
    end
  end
end
