require 'commander'

module Bartlby
  class Worker
    def run!
      until @shutdown
        CONFIG.queue.pull do |message|
          puts "GOT Message #{message.inspect}"
        end
      end
    end
  end
end
