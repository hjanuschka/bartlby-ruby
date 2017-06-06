require 'socket'
require 'sinatra/base'
require 'thin'
module Bartlby
  module API
    class Server < Sinatra::Application
      set :port, 9090
      set :server, "thin"
      set :root, File.dirname(__FILE__)
      set :static, true
      disable :traps
      

      class << self
        attr_reader :sinatra_thread
      end

      get '/hi' do
        "Hello World!"
      end

      get '/exit' do
        exit!(0)
      end

      run! traps: false
    end
  end
end
