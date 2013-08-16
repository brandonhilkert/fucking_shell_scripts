require "fucking_shell_scripts/version"

begin
  require 'pry'
rescue LoadError
end

require_relative 'fucking_shell_scripts/cli'
require_relative 'fucking_shell_scripts/configuration'
require_relative 'fucking_shell_scripts/connection'
require_relative 'fucking_shell_scripts/scp'
require_relative 'fucking_shell_scripts/server'

require_relative 'ext/fog'
