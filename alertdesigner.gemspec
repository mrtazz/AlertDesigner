$:.push File.expand_path('../lib', __FILE__)
require 'alertdesigner'

Gem::Specification.new do |gem|
  gem.name          = 'alertdesigner'
  gem.version       = `git describe --tags --always --dirty`
  gem.authors       = ["Daniel Schauenberg"]
  gem.email         = 'd@unwiredcouch.com'
  gem.homepage      = 'https://github.com/mrtazz/AlertDesigner'
  gem.summary       = "A Ruby DSL for generating Nagios check definitions"
  gem.description   = "A Ruby DSL for generating Nagios check definitions"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "coveralls"

end
