require 'commander'

module Bartlby
  class Worker
    def initialize(bunny: nil)
      @bunny = bunny
    end
    def run!
    @bunny[:queue].subscribe(block: true, consumer_tag: "SCHEDULER") do |delivery_info, properties, body|
        puts " [x] Received #{body}"
        puts delivery_info.inspect
        puts properties.inspect

        # cancel the consumer to exit
      end

    end
  end
end
