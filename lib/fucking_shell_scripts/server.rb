module FuckingShellScripts
  class Server
    NoServerSelected = Class.new(StandardError)
    MissingInstanceID = Class.new(StandardError)

    attr_reader :server

    def initialize(connection, options)
      @connection, @options = connection, options
    end

    def bootstrap
      build
      configure
    end

    def build
      create_server_options = {
        image_id:         options.fetch(:image),
        flavor_id:        options.fetch(:size),
        key_name:         options.fetch(:key_name),
        tags:             { "Name" => name },
        groups:           options.fetch(:security_groups),
        private_key_path: options.fetch(:private_key_path)
      }
      create_server_options.merge!({subnet_id: options[:subnet]}) if options.has_key?(:subnet)
      @server = connection.servers.create(create_server_options)
      @server.username = options.fetch(:username) if options[:username]
      $stdout.print "Creating #{options.fetch(:size)} from #{options.fetch(:image)}"

      server.wait_for do
        $stdout.print "."
        ready?
      end

      $stdout.puts "ready!"
      $stdout.puts ""

      $stdout.print "Waiting for ssh access"

      server.wait_for do
        $stdout.print "."
        sshable?
      end

      $stdout.puts "#{server.dns_name} ready!"
    end

    def configure
      get(options[:instance_id]) if server.nil?
      raise NoServerSelected, "Unable to find server. Try specifying the server ID." if server.nil?

      FuckingShellScripts::SCP.new(server, options).to_server
      server.ssh(options.fetch(:scripts))
    end

    private

    attr_reader :options, :connection

    def get(instance_id)
      raise FuckingShellScripts::Server::MissingInstanceID , "Please specify the instance ID using the --instance-id option." if instance_id.nil?
      @server = connection.servers.get(instance_id)
      @server.private_key_path = options.fetch(:private_key_path)
      @server.username = options.fetch(:username) if options[:username]
      @server
    end

    def name
      "#{options.fetch(:name).downcase.sub(/ /, '-')}-#{Time.now.strftime("%y-%m-%d-%H-%M")}"
    end
  end
end
