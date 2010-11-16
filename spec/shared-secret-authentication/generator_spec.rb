require "spec/spec_helper"


describe SharedSecretAuthentication::Generator do
  describe '.shared_secret' do
    it "should should generate a random secret" do
      SharedSecretAuthentication::Generator.shared_secret.should be_instance_of String
      SharedSecretAuthentication::Generator.shared_secret.should have(10).characters
    end

    it 'should make the shared_secret to be the same length as the passed in integer' do
      SharedSecretAuthentication::Generator.shared_secret(64).should have(64).characters
    end

    it 'should raise an Argument error if the argument is over 64' do
      lambda { SharedSecretAuthentication::Generator.shared_secret(67)}.should raise_error ArgumentError
    end
  end

  describe '.api_key' do
    it 'should respond to api_key' do
      SharedSecretAuthentication::Generator.should respond_to :api_key
    end
  end

end
