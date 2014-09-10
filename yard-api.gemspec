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
  s.homepage    = 'https://github.com/amireh/yard-api-plugin'
  s.files       = Dir.glob("{lib,spec,templates,tasks}/**/*.{rb,erb,rake}") +
                  ['LICENSE', 'README.md', '.rspec', __FILE__]
  s.has_rdoc    = 'yard'
  s.license     = 'MIT'
  s.add_dependency 'yard', '0.8.7'
  s.add_dependency 'yard-appendix', '>=0.1.8'
  s.add_development_dependency 'rspec'
end
