require 'yaml'
require 'digest'

Dir['lib/shared-secret-authentication/*.rb'].each do |file|
  require file
end

