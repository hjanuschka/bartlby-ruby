require 'commander'

module Bartlby
  class DbBase
    def initialize(options = {})
      raise "you need to implement this"
    end

    def load_service(id)
      raise "you need to implement this"
    end

    def save_service(service)
      raise "you need to implement this"
    end

    def needed_services
      raise "you need to implement this"
    end
  end
end
