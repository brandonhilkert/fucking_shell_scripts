require 'fog'

module FuckingShellScripts
  class Connection
    MissingCloudCredentials = Class.new(StandardError)

    def initialize(opts)
      @opts = opts
    end

    def connection
      @connection ||= Fog::Compute.new(parse_cloud_options(@opts.fetch(:cloud)))
    end

    private

    def parse_cloud_options(cloud_opts)
      vars_not_set = []
      cloud_opts.keys.each do |k|
        if cloud_opts[k].index("ENV[") == 0
          env_var = cloud_opts[k].match(/\[\w+\]/).to_s.gsub(/(\[|\])/,'')
          vars_not_set << env_var if ENV[env_var].nil?
          cloud_opts[k] =  ENV[env_var]
        end
      end

      if !vars_not_set.empty?
        msg = "The following environment variables need to be set: #{vars_not_set.join(', ')}"
        raise FuckingShellScripts::Connection::MissingCloudCredentials, msg
      end

      cloud_opts
    end

  end
end
