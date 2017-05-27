require 'commander'

module Bartlby
  class ServiceBase
    attr_accessor :name
    attr_accessor :id
    attr_accessor :type
    attr_accessor :plugin
    attr_accessor :arguments

    def initialize(options = {})
      raise "you need to implement this"
    end

    def run!
      raise "Need to implement this"
    end
  end
end
