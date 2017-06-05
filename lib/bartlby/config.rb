module Bartlby
  class Config
    attr_accessor :config
    attr_accessor :db
    attr_accessor :queue

    class << self
      attr_writer :db
    end

    class << self
      attr_reader :db
    end

    class << self
      attr_writer :queue
    end

    class << self
      attr_reader :queue
    end

    class << self
      attr_writer :config
    end

    class << self
      attr_reader :config
    end
  end
end
