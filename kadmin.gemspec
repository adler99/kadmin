$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'kadmin/version'

Gem::Specification.new do |s|
  s.name        = 'kadmin'
  s.version     = Kadmin::VERSION
  s.authors     = ['Nicolas Pepin-Perreault', 'Sergio Medina', 'Teymour Taghavi']
  s.email       = ['nicolas.pepin-perreault@offerista.com', 'sergio.medina@offerista.com', 'teymour.taghavi@offerista.com']
  s.homepage    = 'https://github.com/offerista/Kadmin'
  s.summary     = 'Collection of utility, configuration, etc., for admin areas'
  s.description = 'Collection of utility, configuration, etc., for admin areas in a Rails application. Provides a boostrap environment, standard layout, authentication, and more.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'test/factories/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  # Core
  s.add_dependency 'rails', '~> 4.2'

  # Front-end stuff
  s.add_dependency 'bootstrap-sass', '~> 3.3'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'jquery-rails', '~> 4.1'
  s.add_dependency 'select2-rails', '~> 4.0'
  s.add_dependency 'omniauth-google-oauth2', '~> 0.4'
end
