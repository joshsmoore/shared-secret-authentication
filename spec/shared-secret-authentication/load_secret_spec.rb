require 'spec_helper'

describe 'load shared secret' do
  it 'should declare a constant SHARED_SECRET' do
    File.stub!(:new)
    Object.const_defined?(:SHARED_SECRET).should be_true
  end

  it 'should load the shared_secret from config/shared_secret.yml' do
    Object.send(:remove_const, :SHARED_SECRET)
    file = StringIO.new("shared_secret : my_shared_secret")
    File.stub!(:new).and_return(file)
    load 'shared-secret-authentication/load_secret.rb'

    SHARED_SECRET.should == 'my_shared_secret'
  end
end
