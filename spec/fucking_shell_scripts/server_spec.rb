require 'spec_helper'
require 'fog/aws/models/compute/server'
require 'fog/aws/models/compute/servers'

module FuckingShellScripts
  describe Server do
    describe '#build' do

      let(:image)             { 'some image' }
      let(:size)              { 'some size' }
      let(:name)              { 'some name' }
      let(:key_name)          { 'some key_name' }
      let(:security_groups)   { 'some security_groups' }
      let(:private_key_path)  { 'some private_key_path' }
      let(:connection)        { double(Fog::Compute) }
      let!(:time)              { Time.now }

      let(:options) do
        {
          image:            image,
          size:             size,
          name:             name,
          key_name:         key_name,
          security_groups:  security_groups,
          private_key_path: private_key_path
        }
      end

      let(:expected_options) do
       {
          image_id:         image,
          flavor_id:        size,
          key_name:         key_name,
          tags:             { "Name" => "#{name.downcase.sub(/ /, '-')}-#{time.strftime("%y-%m-%d-%H-%M")}" },
          groups:           security_groups,
          private_key_path: private_key_path
        }
      end

      subject { Server.new(connection, options).build }

      let(:servers) { double(Fog::Compute::AWS::Servers) }
      let(:server)  { double(Fog::Compute::AWS::Server, wait_for: nil, dns_name: nil) }

      before(:each) do
        allow(connection).to receive(:servers).and_return(servers)
        allow(Time).to receive(:now).and_return(time)
        allow($stdout).to receive(:puts)
        allow($stdout).to receive(:print)
      end

      it 'creates a server with the passed in options' do
        expect(servers).to receive(:create).with(expected_options).and_return(server)

        subject
      end

      context 'when options include subnet' do
        it 'creates a server with the passed in options including the subnet' do
          options.merge!({subnet: 'some subnet'})
          expect(servers).to receive(:create).with(hash_including({subnet_id: 'some subnet'})).and_return(server)

          Server.new(connection, options).build
        end
      end
    end
  end
end
