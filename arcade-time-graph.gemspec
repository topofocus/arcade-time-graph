lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arcade/tg/version'
Gem::Specification.new do |s|
  s.name        = "arcade-time-graph"
#  s.version	= File.open('VERSION').read.strip
  s.version       = Arcade::TG::VERSION
  s.authors     = ["Hartmut Bischoff"]
  s.email       = ["topofocus@gmail.com"]
  s.homepage    = 'https://github.com/topofocus/arcade-time_graph'
  s.licenses    = ['MIT']
  s.summary     = 'Implementation of a time graph with arcadedb'
  s.description = '' 
  s.platform	= Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.date 	= Time.now.strftime "%Y-%m-%d"
  s.test_files  = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.add_development_dependency "bundler"
  # s.add_dependency 'arcadedb'

end
