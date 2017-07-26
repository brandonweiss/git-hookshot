# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "hookshot"

require "bundler"
Bundler.setup

require "minitest/autorun"
require "minitest/reporters"
require "fakefs/safe"

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)
