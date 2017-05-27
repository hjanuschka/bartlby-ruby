require "thread"

module Bartlby
  class NativeQueue < QueueBase
    def initialize(options = {})
      @queue = Queue.new
    end

    def pull
      yield(@queue.pop)
    end

    def post(message)
      @queue << message
    end
  end
end
