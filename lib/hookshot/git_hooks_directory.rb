# frozen_string_literal: true

module Hookshot
  module GitHooksDirectory

    def self.path
      Hookshot.current_working_directory.join(".git/hooks")
    end

  end
end
