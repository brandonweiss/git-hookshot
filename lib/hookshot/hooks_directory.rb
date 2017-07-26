# frozen_string_literal: true

module Hookshot
  module HooksDirectory

    DEFAULT_HOOK_NAMES = %w[
      applypatch-msg
      commit-msg
      post-applypatch
      post-checkout
      post-commit
      post-merge
      post-receive
      post-rewrite
      post-update
      pre-applypatch
      pre-auto-gc
      pre-commit
      pre-push
      pre-rebase
      pre-receive
      prepare-commit-msg
      update
    ].freeze

    def self.exists?
      Dir.exist?(path)
    end

    def self.create_with_default_hooks
      create
      create_default_hooks
    end

    private_class_method def self.create
      puts "`.hooks` directory not found. Creating it…"
      Dir.mkdir(path.to_s)
    end

    private_class_method def self.create_default_hooks
      DEFAULT_HOOK_NAMES.each do |git_hook|
        Hook.new(name: git_hook).create
      end
    end

    def self.hooks
      Dir.glob("#{path}/*").map do |file|
        Hook.new(name: File.basename(file))
      end
    end

    def self.path
      Hookshot.current_working_directory.join(".hooks")
    end

  end
end
