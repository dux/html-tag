version = File.read File.expand_path '.version', File.dirname(__FILE__)

Gem::Specification.new 'html-tag', version do |gem|
  gem.summary     = 'HTML tag builder'
  gem.description = 'Fast and powerful tag builder, upgrade to Rails tag helper, framework agnostic.'
  gem.authors     = ["Dino Reic"]
  gem.email       = 'reic.dino@gmail.com'
  gem.files       = Dir['./lib/**/*.rb']+['./.version']
  gem.homepage    = 'https://github.com/dux/html-tag'
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'fast_blank', '~> 1'
end