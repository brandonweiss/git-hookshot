# frozen_string_literal: true

module Hookshot
  class GitHook

    def initialize(name:)
      @name = name
    end

    def symlink?
      File.symlink?(path)
    end

    def file?
      File.exist?(path)
    end

    def backup
      puts "Existing #{path} found, moving to #{path}.old…"
      FileUtils.move(path, "#{path}.old")
    end

    def symlink(to:)
      puts "Symlinking #{path} to #{to.path}…"
      File.symlink(to.path.to_s, path.to_s)
    end

    private def path
      GitHooksDirectory.path.join(@name)
    end

  end
end
