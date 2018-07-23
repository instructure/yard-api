require File.join(%W[#{File.dirname(__FILE__)} lib yard-api version])

Gem::Specification.new do |s|
  s.name        = 'yard-api'
  s.summary     = "A YARD plugin for documenting APIs in Rails projects."
  s.description = <<-eof
    TBD
  eof
  s.version     = YARD::APIPlugin::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.authors     = ["Ahmad Amireh"]
  s.email       = 'ahmad@instructure.com'
  s.homepage    = 'https://github.com/amireh/yard-api'
  s.files       = Dir.glob("{config,lib,spec,templates,tasks}/**/*") +
                  ['LICENSE', 'README.md', '.rspec', __FILE__]
  s.has_rdoc    = 'yard'
  s.license     = 'AGPL-3.0'
  s.add_dependency 'yard', '~> 0.9.15'
  s.add_dependency 'yard-appendix', '~> 0.1.8'
  s.add_development_dependency 'rspec', '~> 3.3'
end
