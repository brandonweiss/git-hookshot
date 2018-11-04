# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hookshot/version"

Gem.pre_install do |installer|
  require "hookshot"

  output = Hookshot.with_captured_stdout do
    current_working_directory = `lsof -p #{Process.ppid} | grep cwd`.split(" ").last
    Hookshot.link(current_working_directory: current_working_directory)
  end

  installer.spec.post_install_message = output
end

Gem::Specification.new do |spec|
  spec.name          = "git-hookshot"
  spec.version       = Hookshot::VERSION
  spec.authors       = ["Brandon Weiss"]
  spec.email         = ["desk@brandonweiss.me"]

  spec.summary       = "Share git hooks in Ruby projects among all the collaborators automatically"
  spec.description   = "Share git hooks in Ruby projects among all the collaborators automatically, without them having to do anything"
  spec.homepage      = "https://github.com/brandonweiss/git-hookshot"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "fakefs", "~> 0.11.0"
  spec.add_development_dependency "minitest", "~> 5.10.3"
  spec.add_development_dependency "minitest-reporters", "~> 1.1.14"
  spec.add_development_dependency "rake", "~> 12.0.0"
  spec.add_development_dependency "rubocop", "~> 0.53.0"
end
