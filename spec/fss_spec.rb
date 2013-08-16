require 'fss'

describe Fss do
  it "new" do
    Fss::Configuration.any_instance.stub(:settings_file).and_return('spec/support/settings.yml')
    Fss.new()

  end



end

