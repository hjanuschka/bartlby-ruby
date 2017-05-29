require 'socket'
require 'zlib'
require 'openssl'
require "bindata"

module Bartlby
  class V2Packet < BinData::Record
    uint32be :crc32_value
    int16le :exit_code
    int16be :packet_type
    string :output, length: 2048, trim_padding: true
    string :arguments,length: 2048
    string :plugin, length: 2048
    string :perf_handler, length: 1024
    def validate_response
      if @output && @output.include?("\0") 
        @output = @output.split("\0").first
      end
        return self
    end
  end

  class CheckV2
    DEFAULT_OPTIONS = {
                        host: '0.0.0.0',
                        port: '5666',
                        ssl: false
                      }

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      if @options[:ssl]
        @ssl_context = OpenSSL::SSL::SSLContext.new :SSLv23
        @ssl_context.ciphers = 'ADH'
        @ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(@options.fetch(:ssl_cert))) unless @options[:ssl_cert].nil?
        @ssl_context.key = OpenSSL::PKey::RSA.new(File.open(@options.fetch(:ssl_key))) unless @options[:ssl_key].nil?
      end
    end

    def run()
      query = V2Packet.new
      query.packet_type = 1
      query.plugin = @options[:plugin]
      query.arguments = @options[:arguments]
      query.output = ""
      query.perf_handler = ""
      query.exit_code = -1
      query.crc32_value = 0

      query.crc32_value = Zlib::crc32(query.to_binary_s)



      begin
        socket = TCPSocket.open(@options[:host], @options[:port])

        if @options[:ssl]
          socket = OpenSSL::SSL::SSLSocket.new(socket, @ssl_context)
          socket.sync_close = true
          socket.connect
        end

        socket.write(query.to_binary_s)
        bin = socket.read(11*1024)
        response = V2Packet.read(bin);
        response.plugin = ""
        response.arguments = ""
        socket.close
        return response
      rescue Errno::ETIMEDOUT
        raise 'NRPE request timed out'
      end
    end
  end
end

a = Bartlby::CheckV2.new({host: "212.186.195.202", port: 9030, ssl: true, plugin: "bartlby_load", arguments: "-c 0 -p"})
puts a.run.validate_response
