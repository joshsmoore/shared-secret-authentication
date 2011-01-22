require 'spec/spec_helper'

describe 'load shared secret' do
  it 'should declare a constant SHARED_SECRET' do
    File.stub!(:new)
    Object.const_defined?(:SHARED_SECRET).should be_true
  end

  it 'should load the shared_secret from config/shared_secret.yml' do
    file = StringIO.new("shared_secret : my_shared_secret")
    File.stub!(:new).and_return(file)
    require 'lib/shared-secret-authentication/load_secret'

    SHARED_SECRET.should == 'my_shared_secret'
  end
end
