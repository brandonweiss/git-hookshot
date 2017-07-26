# git-hookshot

[![Gem Version](https://badge.fury.io/rb/git-hookshot.svg)](https://badge.fury.io/rb/git-hookshot) [![Build Status](https://travis-ci.org/brandonweiss/git-hookshot.svg?branch=master)](https://travis-ci.org/brandonweiss/git-hookshot)

<img src="https://cloud.githubusercontent.com/assets/4727/20847858/9d3c4ef8-b884-11e6-8bcc-8c2c493c60b3.png" width="60%">

git-hookshot allows you to share git hooks in Ruby projects among all the collaborators _automatically_, without them having to do anything. It automatically symLINKs them to the internal git hooks directory when installing gems with Bundler.

There are several other tools somewhat similar to this, but all of them require each collaborator working on a repository to run a specific command that generates the git hooks, and if they don’t then nothing happens. On a large project that can result in an untenable situation where unintentionally everyone has a different development experience.

npm has install hooks that can be easily hooked into it but Bundler and RubyGems don’t really. And yet a way has been found…

⚠️ **Caveat emptor** ⚠️

This entire gem runs on 🔮 dark magic 🔮. What it does isn’t intended to be possible to do, but it draws on the arcane power of defining gem install hooks _inside_ the gemspec in order to setup the git hooks during bundling and then dynamically overwrite the `post_install_message` in order to surface the explanatory output from the depths of where the gem install hook is called. I wouldn’t think too much about it. _If you gaze long into an abyss, the abyss also gazes into you._

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "git-hookshot"
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install git-hookshot
```

## Usage

git-hookshot is automatically run when bundling and will figure out what the right thing to do is given the state of your git hooks.

If you’re the first person to start using git-hookshot and you have no shared hooks, it will create empty shared hooks in `.hooks/` and symlink them to the internal git hook files at `.git/hooks/`. If you have existing internal git hooks they will be safely moved out of the way and a suffix of `.old` will be added to them.

You should add whatever logic you want to whatever hooks you want and then commit them to the repository.

When another collaborator pulls your changes which add git-hookshot and the shared git hooks Bundler will complain that there are new gems that need to be installed. When they bundle, git-hookshot will see the shared git hooks and create symlinks to the internal git hooks directory, enabling the shared git hooks. Collaborators don’t have to do anything extra—it just works.

git-hookshot can also be manually called with `bundle exec git-hookshot` if you need to re-generate a symlink or something.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brandonweiss/git-hookshot.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
