require 'spec_helper'

describe SharedSecretAuthentication do
  before(:all) do
    Object.send(:remove_const, :SHARED_SECRET)
    Object.const_set(:SHARED_SECRET, 'test')
  end

  describe '.standarize_string' do
    it 'should produce the same hash for all arrays no matter what the order'

  end

  describe '.sign_hash' do
    it 'should respond to sign_hash' do
      SharedSecretAuthentication.should respond_to :sign_hash
    end

    it 'should add a "signature" key to the hash ' do
      SharedSecretAuthentication.sign_hash({'test' => 'me'}).keys.should include 'signature'
    end

    it 'should assign the signature of the hash plus the shared string and make this the value of signature' do
      SharedSecretAuthentication.sign_hash('test' => 'me')['signature'].should == '95f5e1e8bc0f836d233fd108393d56f3c5532830c3fc29f54bd3a208de9699fd'
    end
  end

  describe '.check_hash_signature' do
    it 'should respond to check_hash_signature' do
      SharedSecretAuthentication.should respond_to :hash_signature_correct?
    end

    it 'should raise an arguemtn error if the hash is not signed' do
      lambda {SharedSecretAuthentication.hash_signature_correct?({})}.should raise_error ArgumentError
    end


    it 'should return true if the signature matches the expected signature' do
      SharedSecretAuthentication.hash_signature_correct?({'test' => 'me', 'signature' => '95f5e1e8bc0f836d233fd108393d56f3c5532830c3fc29f54bd3a208de9699fd'}).should be_true
    end

    it 'should return false if the signatures do not match' do
      SharedSecretAuthentication.hash_signature_correct?({'test' => 'me', 'signature' => '95f5e1e8bc0f836d233fd108393d56f3c5532830c3fc29f54bd3a200de9699fd'}).should be_false
    end
  end

  describe '.hash_signature' do
    it 'should calculate the checksum of the hash plus the shared string and make this the value of signature' do
      SharedSecretAuthentication.hash_signature('test' => 'me').should == '95f5e1e8bc0f836d233fd108393d56f3c5532830c3fc29f54bd3a208de9699fd'
    end

    it 'should not matter what order the hash is defined it it should produce the same signature' do
      SharedSecretAuthentication.hash_signature({'test' => 'me', 'different' => 'order', '1' => '2'}).should == SharedSecretAuthentication.hash_signature({'1' => '2', 'different' => 'order', 'test' => 'me'})
    end

    it 'should work for hash keys that are symbols' do
      SharedSecretAuthentication.hash_signature(:test => 'me', :key => 'test').should == 'b1a4b3df933590f973f07e6f0a391e95a8423e7b5250973f24e3174d60e8a1ac'
    end

    it 'should work if the hash is signed in a different time zone' do
      SharedSecretAuthentication.hash_signature_correct?({'visits' => {'visit_date' => Time.parse('2010-06-04T16:48:46Z'), 'mysql_id' => 1}, 'signature' => "d461a73c904fe4cd55b0eaa7212a89973f3126067bccf97775767575a26a148f"}).should be_true
    end

    it 'should work in different timezones or top level times' do
      SharedSecretAuthentication.hash_signature_correct?({'visit_date' => Time.parse('2010-06-04T16:48:46Z'), 'signature' => "dc951a85cde77e5c10154e6284f2facc61393324ce84a9b5ecfe18d950a1e119"}).should be_true
    end

    it 'should convert dates in the array to strings' do
      date = Date.today
      d = Digest::SHA2.new
      d.update 'eval_dates'
      d.update date.strftime('%a %b %m %H:%M:%S %Y')
      d.update SHARED_SECRET

      SharedSecretAuthentication.hash_signature({'eval_dates' => [date]}).should == d.to_s
    end

    context 'edge cases' do

      it 'should produce the same signature for date objects if the date is converted into a time' do
        hash1 = {"cases" => {'last_date_seen' => Date.parse("Thu, 22 Apr 2010")}}
        hash2 = {"cases" => {'last_date_seen' => Time.utc(2010, 4, 22)}}

        SharedSecretAuthentication.hash_signature(hash1).should == SharedSecretAuthentication.hash_signature(hash2)
      end

      it 'should produce the same signature for both hashes' do
        hash1 = {"practices"=>{"name"=>"Body Image Physical Therapy & Fitness P.C.", "mysql_updated_at"=>Time.parse("Thu, 03 Jun 2010 19:15:03 UTC +00:00"), "mysql_id"=>79}}
        hash2 = {"practices"=>{"mysql_updated_at"=>Time.parse("2010-06-03T19:15:03Z"), "name"=>"Body Image Physical Therapy & Fitness P.C.", "mysql_id"=>79}}

        SharedSecretAuthentication.hash_signature(hash1).should == SharedSecretAuthentication.hash_signature(hash2)
      end

      it 'should produce the same signature for times in different formats' do
        hash1 = {"practices"=>{"name"=>"Body Image Physical Therapy & Fitness P.C.", "mysql_updated_at"=>DateTime.parse("Thu, 03 Jun 2010 19:15:03 UTC +00:00"), "mysql_id"=>79}}
        hash2 = {"practices"=>{"mysql_updated_at"=>Time.parse("2010-06-03T19:15:03Z"), "name"=>"Body Image Physical Therapy & Fitness P.C.", "mysql_id"=>79}}

        SharedSecretAuthentication.hash_signature(hash1).should == SharedSecretAuthentication.hash_signature(hash2)
      end
    end
  end
end
