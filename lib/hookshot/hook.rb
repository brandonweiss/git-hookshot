# frozen_string_literal: true

module Hookshot
  class Hook

    attr_reader :name

    def initialize(name:)
      @name = name
    end

    def create
      puts "Creating empty #{@name} hook at #{path}…"
      FileUtils.touch(path)
    end

    def path
      HooksDirectory.path.join(@name)
    end

  end
end
