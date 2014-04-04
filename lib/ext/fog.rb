require 'fog'
require 'fog/core/ssh'

# Monkey-patch Fog 1.3.1 to stream SSH output
# (in real time) to stdout.
class Fog::SSH::Real
  def run(commands)
    commands = [*commands]
    results  = []
    begin
      Net::SSH.start(@address, @username, @options) do |ssh|
        commands.each do |command|
          result = Fog::SSH::Result.new(command)
          ssh.open_channel do |ssh_channel|
            ssh_channel.request_pty
            ssh_channel.exec(command) do |channel, success|
              unless success
                raise "Could not execute command: #{command.inspect}"
              end

              channel.on_data do |ch, data|
                result.stdout << data
                print data
              end

              channel.on_extended_data do |ch, type, data|
                next unless type == 1
                result.stderr << data
                print data
              end

              channel.on_request('exit-status') do |ch, data|
                result.status = data.read_long
              end

              channel.on_request('exit-signal') do |ch, data|
                result.status = 255
              end
            end
          end
          ssh.loop
          results << result
        end
      end
    rescue Net::SSH::HostKeyMismatch => exception
      exception.remember_host!
      sleep 0.2
      retry
    end
    results
  end
end

