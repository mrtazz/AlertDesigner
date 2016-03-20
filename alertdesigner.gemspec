$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "English"

Gem::Specification.new do |gem|
  gem.name          = "alertdesigner"
  gem.version       = `git describe --tags --abbrev=0`
  gem.authors       = ["Daniel Schauenberg"]
  gem.email         = "d@unwiredcouch.com"
  gem.homepage      = "https://github.com/mrtazz/AlertDesigner"
  gem.summary       = "A Ruby DSL for generating Nagios check definitions"
  gem.description   = "A Ruby DSL for generating Nagios check definitions"

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake", "11.1.1"
  gem.add_development_dependency "coveralls"
  gem.add_development_dependency "rubocop", "~> 0.38"
  gem.add_development_dependency "test-unit"
end
