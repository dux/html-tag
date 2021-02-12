version  = File.read File.expand_path '.version', File.dirname(__FILE__)
gem_name = 'html-tag'

Gem::Specification.new gem_name, version do |gem|
  gem.summary     = 'HTML tag builder'
  gem.description = 'Fast and powerful tag builder, upgrade to Rails tag helper, framework agnostic.'
  gem.authors     = ["Dino Reic"]
  gem.email       = 'reic.dino@gmail.com'
  gem.files       = Dir['./lib/**/*.rb']+['./.version']
  gem.homepage    = 'https://github.com/dux/%s' % gem_name
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'fast_blank', '~> 1'
end