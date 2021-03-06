# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife/vm/version'

Gem::Specification.new do |gem|
  gem.name          = "knife-vm"
  gem.version       = Knife::VM::VERSION
  gem.authors       = ["Dan Ryan"]
  gem.email         = ["dan@appliedawesome.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "chef", ">= 10.0"

  gem.add_development_dependency "rspec", "~> 2.12"
end
