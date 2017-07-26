# frozen_string_literal: true

require "test_helper"

describe Hookshot do

  before do
    FakeFS.activate!
    FakeFS::FileSystem.clear

    Dir.mkdir(pwd.join(".git").to_s)
    Dir.mkdir(pwd.join(".git/hooks").to_s)
  end

  after do
    FakeFS.deactivate!
  end

  def pwd
    Pathname.new(Dir.pwd)
  end

  it "has a version number" do
    Hookshot::VERSION.wont_be_nil
  end

  describe "::link" do

    it "does not create the hooks directory if it already exists" do
      Dir.mkdir("#{Dir.pwd}/.hooks")

      Hookshot.link
    end

    it "creates the hooks directory if it does not exist" do
      capture_io do
        Hookshot.link
      end

      Dir.exist?("#{Dir.pwd}/.hooks").must_equal true
    end

    it "creates the hooks directory in a specific current working directory" do
      Dir.mkdir("/other")
      Dir.mkdir("/other/.git")
      Dir.mkdir("/other/.git/hooks")

      capture_io do
        Hookshot.link(current_working_directory: "/other")
      end

      Dir.exist?("/other/.hooks").must_equal true
    end

    it "creates a hook file for each git hook in the hooks directory if it does not exist" do
      capture_io do
        Hookshot.link
      end

      Hookshot::HooksDirectory::DEFAULT_HOOK_NAMES.each do |git_hook|
        File.exist?(pwd.join(".hooks/#{git_hook}")).must_equal true
      end
    end

    it "does nothing if the symlink already exists" do
      Dir.mkdir(pwd.join(".hooks").to_s)
      FileUtils.touch(pwd.join(".hooks/pre-commit"))

      File.symlink(pwd.join(".hooks/pre-commit"), pwd.join(".git/hooks/pre-commit"))

      Hookshot.link
    end

    it "moves an existing Git hook out of the way so it does’t overwrite it" do
      Dir.mkdir(pwd.join(".hooks").to_s)
      FileUtils.touch(pwd.join(".hooks/pre-commit"))

      File.write(pwd.join(".git/hooks/pre-commit"), "foobar")

      capture_io do
        Hookshot.link
      end

      File.symlink?(pwd.join(".git/hooks/pre-commit")).must_equal true
      File.readlink(pwd.join(".git/hooks/pre-commit")).must_equal "#{Dir.pwd}.hooks/pre-commit"

      File.exist?(pwd.join(".git/hooks/pre-commit.old")).must_equal true
      File.read(pwd.join(".git/hooks/pre-commit.old")).must_equal "foobar"
    end

    it "creates symlinks for each hook" do
      Dir.mkdir(pwd.join(".hooks").to_s)
      FileUtils.touch(pwd.join(".hooks/pre-commit"))
      FileUtils.touch(pwd.join(".hooks/post-commit"))

      capture_io do
        Hookshot.link
      end

      File.symlink?(pwd.join(".git/hooks/pre-commit")).must_equal true
      File.symlink?(pwd.join(".git/hooks/post-commit")).must_equal true

      File.readlink(pwd.join(".git/hooks/pre-commit")).must_equal "#{Dir.pwd}.hooks/pre-commit"
      File.readlink(pwd.join(".git/hooks/post-commit")).must_equal "#{Dir.pwd}.hooks/post-commit"
    end

  end

end
