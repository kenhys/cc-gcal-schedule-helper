# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "colleagues/calendar/command/version"

Gem::Specification.new do |spec|
  spec.name          = "colleagues-calendar-command"
  spec.version       = Colleagues::Calendar::Command::VERSION
  spec.authors       = ["Kentaro Hayashi"]
  spec.email         = ["hayashi@clear-code.com"]

  spec.summary       = %q{Input helper tool for Collegues calendar}
  spec.description   = %q{This tool helps to input schedule with specific format.}
  spec.homepage      = "https://github.com/kenhys/colleagues-calendar-command"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("google_calendar")
  spec.add_runtime_dependency("highline")

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
