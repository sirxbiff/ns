# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ns/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jaimie van Santen"]
  gem.email         = ["jaimie@jaimievansanten.nl"]
  gem.description   = %q{Provides a Ruby wrapper for the Dutch NS API}
  gem.summary       = %q{ns api}
  gem.homepage      = "https://github.com/jaimie-van-santen/ns"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ns"
  gem.require_paths = ["lib"]
  gem.version       = Ns::VERSION

  gem.add_dependency("xml-simple")
end
