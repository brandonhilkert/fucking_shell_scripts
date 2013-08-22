require 'spec_helper'

module FuckingShellScripts
  describe Connection do
    it "initializes" do
      Connection.new({})
    end

    describe "parsing environment variable options" do
      let(:opts) { {cloud: {non_env: 'none', from_env_var: 'ENV[FSS_TEST_ENV_VAR]'}}}
      let(:correctly_parsed_opts) { {non_env: 'none', from_env_var: 'yup'}}

      before { ENV['FSS_TEST_ENV_VAR'] = 'yup'}
      it "parses options meant to be environment variables" do
        Fog::Compute.should_receive(:new).with(correctly_parsed_opts)
        Connection.new(opts).connection
      end

      let(:opts_with_a_not_set_env_var) { {cloud: {non_env: 'none', from_env_var: 'ENV[FSS_TEST_ENV_VAR_NOT_SET]'}}}
      it "blows up if an env var is specified but not set" do
        msg = "The following environment variables need to be set: FSS_TEST_ENV_VAR_NOT_SET"
        lambda { Connection.new(opts_with_a_not_set_env_var).connection }.should raise_error(FuckingShellScripts::Connection::MissingCloudCredentials, msg)
      end
    end
  end
end
