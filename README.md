# Tailwind for Middleman

Probably the easiest way to get [Tailwind CSS](https://tailwindcss.com/) into your Middleman app! It uses the `tailwindcss-ruby` gem, no npm or external pipelines needed.

Note: Only supports Tailwindcss v4.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman-tailwind'
```

And then execute:

$ bundle install

Or install it yourself as:

$ gem install middleman-tailwind

### Optional: Install Watchman for Faster File Watching

If you see the following warning:

```sh
sh: 1: watchman: not found
```

Tailwind will still work correctly, but it will fall back to a slower file-watching method (polling). To enable faster and more efficient rebuilds, you can optionally install [Watchman](https://facebook.github.io/watchman/), a file-watching service developed by Meta.

#### Install Watchman

Choose the command for your system:

**macOS (Homebrew):**

```bash
brew install watchman
```

**Ubuntu / Debian:**

```bash
sudo apt update
sudo apt install watchman
```

**Arch Linux:**

```bash
pacman -S watchman
```

> Note: This is entirely optional — Tailwind will still function without Watchman, just with slower file change detection.

## Usage

If you don't have any special configuration needs, things should just work out of the box if you activate the extension in your `config.rb`:

```ruby
activate :tailwind,
  css_path: "custom/input.css",        # Optional  
  destination_path: ".tmp/main.css",   # Optional
  latency: 0.5                         # Optional
```

By default the output file will be at `./tailwind.css`, this file do not need to be committed and can be added to `.gitignore`.

When you start your middleman server, a thread will spin up with the tailwind CLI in `watch` mode, watching for changes in all the `.erb` files under your `source` directory. The default path for your generated tailwind CSS file is `source/stylesheets/tailwind.css`, but you can change that with a configuration option:

```ruby
activate :tailwind do |config|
  config.destination_path = "source/stylesheets/another-filename.css"
end
```

In the same vein, you can customize the application css that tailwind uses, like so:

```ruby
activate :tailwind do |config|
  config.css_path = "tailwind/application.tailwind.css"
end
```

Note: The default tailwind.css file looks like this. This file is where you can change the path to your own custom config.js file.

```
@config "./tailwind.config.js";
@import "tailwindcss";
```

That's all. GLHF!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bendangelo/middleman-tailwind.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
