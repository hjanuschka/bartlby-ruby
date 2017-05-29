require 'socket'
require 'zlib'
require 'openssl'

module Bartlby
  class V2Packet
    QUERY_PACKET = 1
    RESPONSE_PACKET = 2

    MAX_PACKET_SIZE = 12*1024

    attr_accessor :crc32, :exit_code, :packet_type, :output, :arguments, :plugin, :perf_handler 
    def initialize(unpacked = nil)
      if unpacked
        @crc32          = unpacked[0]
        @exit_code    = unpacked[1]
        @packet_type    = unpacked[2]
        @output         = unpacked[3]
        @arguments         = unpacked[4]
        @plugin         = unpacked[5]
        @perfdata         = unpacked[6]
      end
    end

    def packet_type
      case @packet_type
      when QUERY_PACKET    then :query
      when RESPONSE_PACKET then :response
      end
    end

    def packet_type=(type)
      case type
      when :query    then @packet_type = QUERY_PACKET
      when :response then @packet_type = RESPONSE_PACKET
      else
        raise "Invalid packet type"
      end
    end

    def calculate_crc32
      Zlib.crc32(self.to_bytes(0))
    end

    def validate_crc32
      raise 'Invalid CRC32' unless @crc32 == self.calculate_crc32
    end

    def strip_buffer
      self.buffer = self.buffer.strip
    end

    def to_bytes(use_crc32 = self.calculate_crc32)
      a =  [use_crc32, @exit_code, @packet_type, @output, @arguments, @plugin, @perf_handler]
      a.pack("Nnna2048a2048a2048a1024")
    end

    def self.read(io, validate_crc32 = true)
      bytes = io.read(MAX_PACKET_SIZE)
      values = bytes.unpack("NnnZ2048Z2048Z2048Z1024")
      packet = self.new(values)
      packet.plugin = ""
      packet.arguments = ""
      packet.validate_crc32 if validate_crc32
      packet
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
      query.packet_type = :query
      query.plugin = @options[:plugin]
      query.arguments = @options[:arguments]
      query.output = ""
      query.perf_handler = ""
      query.exit_code = -1
      begin
        socket = TCPSocket.open(@options[:host], @options[:port])

        if @options[:ssl]
          socket = OpenSSL::SSL::SSLSocket.new(socket, @ssl_context)
          socket.sync_close = true
          socket.connect
        end

        socket.write(query.to_bytes)
        response = V2Packet.read(socket, !@options[:ssl])
        socket.close
        return response
      rescue Errno::ETIMEDOUT
        raise 'NRPE request timed out'
      end
    end
  end
end

a = Bartlby::CheckV2.new({host: "212.186.195.202", port: 9030, ssl: true, plugin: "bartlby_load", arguments: "-c 20"})
puts a.run.inspect
