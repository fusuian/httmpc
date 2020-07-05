# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "httmpc/version"

Gem::Specification.new do |spec|
  spec.name          = "httmpc"
  spec.version       = Httmpc::VERSION
  spec.authors       = ["ASAHI,Michiharu"]
  spec.email         = ["fusuian@gmail.com"]

  spec.summary       = %q{mpd client for browser}
  spec.description   = %q{An mpd client that acts as a web server. You can operate the mpd server from any browser.}
  spec.homepage      = "https://github.com/fusuian/httmpc"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new("~> 2.5")


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = %w(httmpc)
  spec.require_paths = ["lib"]

  spec.add_dependency "net-telnet", "~> 0.2"
  spec.add_dependency "sys-filesystem", "~> 1.3"
  spec.add_dependency "thin", "~> 1.7"
  spec.add_dependency "sinatra", "~> 2.0"
  spec.add_dependency "sinatra-contrib", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", ">= 12.3.3"
end
