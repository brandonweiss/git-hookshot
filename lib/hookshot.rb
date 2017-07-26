# frozen_string_literal: true

require "hookshot/git_hook"
require "hookshot/git_hooks_directory"
require "hookshot/hook"
require "hookshot/hooks_directory"
require "hookshot/version"

require "pathname"
require "fileutils"

module Hookshot

  def self.link(current_working_directory: nil)
    @current_working_directory = current_working_directory

    HooksDirectory.create_with_default_hooks unless HooksDirectory.exists?

    HooksDirectory.hooks.each do |hook|
      git_hook = GitHook.new(name: hook.name)

      next if git_hook.symlink?
      git_hook.backup if git_hook.file?

      git_hook.symlink(to: hook)
    end
  end

  def self.current_working_directory
    path = @current_working_directory || Dir.pwd
    Pathname.new(path)
  end

  def self.with_captured_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end

end
