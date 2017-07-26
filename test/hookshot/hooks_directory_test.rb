# frozen_string_literal: true

require "test_helper"

describe Hookshot::HooksDirectory do

  def subject
    Hookshot::HooksDirectory
  end

  it "has a list of all the git hooks" do
    subject::DEFAULT_HOOK_NAMES.must_equal %w[
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
    ]
  end

end
