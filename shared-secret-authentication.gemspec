# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shared-secret-authentication/version'

Gem::Specification.new do |spec|
  spec.name             = %q{shared-secret-authentication}
  spec.version          = SharedSecretAuthentication::VERSION
  spec.authors          = ["Josh Moore"]
  spec.email            = %q{joshsmoore@gmail.com}
  spec.description      = %q{helper methods to make shared secret authentication easier}
  spec.summary          = %q{helper methods to make shared secret authentication easier}
  spec.date             = %q{2013-05-20}
  spec.homepage         = %q{http://github.com/joshsmoore@gmail.com/shared-secret-authentication}

  spec.files            = `git ls-files`.split($/)
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]
  spec.extra_rdoc_files = ["LICENSE", "README.rdoc"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
