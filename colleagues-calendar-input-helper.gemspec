# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "colleagues/calendar/input/helper/version"

Gem::Specification.new do |spec|
  spec.name          = "colleagues-calendar-input-helper"
  spec.version       = Colleagues::Calendar::Input::Helper::VERSION
  spec.authors       = ["Kentaro Hayashi"]
  spec.email         = ["hayashi@clear-code.com"]

  spec.summary       = %q{Input helper tool for Collegues calendar}
  spec.description   = %q{This tool helps to input schedule with specific format.}
  spec.homepage      = "https://github.com/kenhys/colleagues-calendar-input-helper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("google_calendar")

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
