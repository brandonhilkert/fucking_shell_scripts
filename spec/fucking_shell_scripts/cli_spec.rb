require 'spec_helper'

module FuckingShellScripts
  describe CLI do
    let(:server) { double('server', bootstrap: true, build: true, configure: true) }
    let(:options) {
      {
        type: "test-server",
        region: "us-east-1",
      }
    }
    let(:config) { double('config', options: options) }

    it "initializes a server with the connection" do
      connection = double('connection')
      connection_obj = double('obj connection', connection: connection)
      FuckingShellScripts::Connection.stub(:new).and_return(connection_obj)
      FuckingShellScripts::Configuration.stub(:new).and_return(config)
      FuckingShellScripts::Server.should_receive(:new).with(connection, options)
      FuckingShellScripts::CLI.new.bootstrap
    end

    context "instance methods" do
      before :each do
        ENV["AWS_ACCESS_KEY"] = "key"
        ENV["AWS_SECRET_ACCESS_KEY"] = "secret"
        FuckingShellScripts::Configuration.stub(:new).and_return(config)
        FuckingShellScripts::Server.stub(:new).and_return(server)
      end

      it "bootstraps a server" do
        expect(server).to receive(:bootstrap)
        FuckingShellScripts::CLI.new.bootstrap
      end

      it "builds a server" do
        expect(server).to receive(:build)
        FuckingShellScripts::CLI.new.build
      end

      it "configures a server" do
        expect(server).to receive(:configure)
        FuckingShellScripts::CLI.new.configure
      end

    end
  end
end
