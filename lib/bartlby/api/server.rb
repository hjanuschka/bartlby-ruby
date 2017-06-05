require 'socket'
require 'sinatra/base'
require 'thin'
module Bartlby
  module API
    class Server < Sinatra::Application
      set :port, 9090
      set :server, "thin"

      class << self
        attr_reader :sinatra_thread
      end

      get '/hi' do
        "Hello World!"
      end

      get '/exit' do
        exit!(0)
      end

      run!
    end
  end
end
