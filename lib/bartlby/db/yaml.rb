require 'commander'
require 'yaml'

module Bartlby
  class DbYaml < DbBase
    def initialize(configuration: nil)
      @yaml_file = File.expand_path(configuration["db"]["yaml"]["path"])
      @yaml = {}
      @yaml = YAML.load_file(@yaml_file) if File.exist?(@yaml_file)
    end

    def load_service(id)
      @yaml["services"][id.to_i] if @yaml["services"][id.to_i]
      return false
    end

    def save_service(service)
      @yaml["services"][id] = service
    end

    def needed_services
      needed_svc = []
      @yaml["services"].each do |key, value|
        # FIXME: instanicate service
        needed_svc << value
      end
    end
  end
end
