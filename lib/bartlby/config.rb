module Bartlby
  class Config
    attr_accessor :config
    attr_accessor :db
    attr_accessor :queue

    def self.db=(db)
      @db = db
    end
    def self.db
      @db
    end

    def self.queue=(q)
      @queue = q
    end
    def self.queue
      @queue
    end

    def self.config=(cfg)
      @config = cfg
    end
    def self.config
      @config
    end
  end
end
