require 'commander'

module Bartlby
  class QueueBase
    def initialize(options = {})
      raise "you need to implement this"
    end

    def pull
      raise "you need to implement this"
    end

    def post(message)
      raise "you need to implement this"
    end
  end
end
