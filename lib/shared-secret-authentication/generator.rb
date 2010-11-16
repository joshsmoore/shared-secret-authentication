module SharedSecretAuthentication
  class Generator

    def self.shared_secret(length = 10)
      raise ArgumentError.new 'a key has a maximum of 64 numbers and letters' if length > 64
      Digest::SHA2.hexdigest(Time.now.to_s + rand(123456789).to_s)[0..length - 1]
    end

    class << self
      alias :api_key :shared_secret
    end
  end
end