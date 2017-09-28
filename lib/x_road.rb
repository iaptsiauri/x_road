require 'require_all'
require 'x_road/version'
require 'uuidtools'
require 'savon'
require 'x_road/active_x_road3'

module XRoad
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    Client = Struct.new(:member_class, :member_code, :subsystem_code)
    Service = Struct.new(:member_class, :member_code, :subsystem_code, :service_code, :version)

    attr_accessor :instance
    attr_accessor :protocol_version
    attr_accessor :host
    attr_accessor :client_cert
    attr_accessor :client_key
    attr_accessor :log_level
    attr_accessor :ssl_verify

    attr_reader :service
    attr_reader :client

    def initialize
      @log_level = :info
      @ssl_verify = :none
    end

    def client=(opts)
      @client = Client.new(opts[:member_class],
                           opts[:member_code],
                           opts[:subsystem_code])
    end

    def service=(opts)
      @service = Service.new(opts[:member_class],
                             opts[:member_code],
                             opts[:subsystem_code],
                             opts[:service_code],
                             opts[:version])
    end
  end
end
