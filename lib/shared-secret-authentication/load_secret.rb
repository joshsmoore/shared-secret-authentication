require 'yaml'

puts File.new('config/shared_secret.yml').read
puts YAML.load(File.new('config/shared_secret.yml')).inspect
SHARED_SECRET = YAML.load(File.new('config/shared_secret.yml'))
