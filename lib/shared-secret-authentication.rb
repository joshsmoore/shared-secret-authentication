require 'yaml'
require 'digest'

#Dir['shared-secret-authentication/*.rb'].each do |file|
#  puts file
#  require file
#end
require 'shared-secret-authentication/load_secret'
require 'shared-secret-authentication/hash_signatures'
require 'shared-secret-authentication/generator'
