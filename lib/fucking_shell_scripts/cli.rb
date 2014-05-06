module FuckingShellScripts
  class CLI
    MissingCloudSettings = Class.new(StandardError)

    def initialize(opts = {})
      @opts = opts
    end

    def bootstrap
      server.bootstrap
    end

    def build
      server.build
    end

    def configure
      server.configure
    end

    private

    def server
      @server ||= FuckingShellScripts::Server.new(connection, options)
    end

    def connection
      FuckingShellScripts::Connection.new(options.fetch(:cloud)).connection
    end

    def options
      @options ||= FuckingShellScripts::Configuration.new(@opts).options

      if @options.has_key? :ssh_ip_address
        # pass
      elsif @options.has_key? :vpn and @options.fetch(:vpn)
        @options[:ssh_ip_address] = Proc.new {|server| server.private_ip_address }
      else
        @options[:ssh_ip_address] = Proc.new {|server| server.public_ip_address }
      end

      @options
    end
  end
end
