require 'commander'

module Bartlby
  class Scheduler
   def initialize(bunny: nil)
     @bunny = bunny
   end
   def run!
     while true
       puts "SCHEDULER"
       @bunny[:queue].publish("some job", routing_key: "KEY", consumer_tag: "BTL_SCHEDULER")
       sleep 10
     end
   end
  end
end
