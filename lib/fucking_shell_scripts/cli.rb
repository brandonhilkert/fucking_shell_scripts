module FuckingShellScripts
  class CLI
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
      FuckingShellScripts::Server.new(connection, options)
    end

    def connection
      FuckingShellScripts::Connection.new(options).connection
    end

    def options
      @options ||= FuckingShellScripts::Configuration.new(@opts).options
    end
  end
end
