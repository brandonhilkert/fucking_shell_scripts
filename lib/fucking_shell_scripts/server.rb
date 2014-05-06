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
      build_options = {
        image_id: options.fetch(:image),
        flavor_id: options.fetch(:size),
        key_name: options.fetch(:key_name),
        tags: { "Name" => name },
        groups: options.fetch(:security_groups),
        ssh_ip_address: options.fetch(:ssh_ip_address),
      }

      build_options[:username] = options.fetch(:ssh_username) if options.has_key? :ssh_username

      if options.has_key? :private_key_path
        build_options[:private_key_path] = options.fetch(:private_key_path)
      elsif options.has_key? :key_name
        build_options[:key_name] = options.fetch(:key_name)
      end

      [:vpc_id, :subnet_id].each do |key|
        if options.has_key? key
          build_options[key] = options.fetch(key)
        end
      end

      @server = connection.servers.create(build_options)

      print "Creating #{options.fetch(:size)} from #{options.fetch(:image)}"

      server.wait_for do
        print "."
        ready?
      end

      puts "ready!"
      puts ""

      print "Waiting for ssh access"

      server.wait_for do
        print "."
        sshable?
      end

      puts "#{server.dns_name} ready!"
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
      @server.ssh_ip_address = options.fetch(:ssh_ip_address)
      @server.username = options.fetch(:ssh_username) if options.has_key? :ssh_username
      @server
    end

    def name
      "#{options.fetch(:name).downcase.sub(/ /, '-')}-#{Time.now.strftime("%y-%m-%d-%H-%M")}"
    end
  end
end
