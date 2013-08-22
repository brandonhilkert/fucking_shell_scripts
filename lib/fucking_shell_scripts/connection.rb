require 'fog'

module FuckingShellScripts
  class Connection
    def initialize(opts)
      @opts = opts
    end

    def connection
      Fog::Compute.new(@opts)
    end
  end
end
