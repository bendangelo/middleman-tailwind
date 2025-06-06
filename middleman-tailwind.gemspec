require_relative "lib/middleman/tailwind/version"

Gem::Specification.new do |spec|
  spec.name = "middleman-tailwind"
  spec.version = Middleman::Tailwind::VERSION
  spec.authors = ["Johan Halse"]
  spec.email = ["johan@hal.se"]

  spec.summary = "The easiest way to get Tailwind CSS in your Middleman project"
  spec.description = "A Middleman extension that comes bundled with standalone executables, no configuration needed."
  spec.homepage = "https://github.com/johanhalse/middleman-tailwind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/johanhalse/middleman-tailwind"
  spec.metadata["changelog_uri"] = "https://github.com/johanhalse/middleman-tailwind/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency("middleman-core", [">= 4.0.0"])
  spec.add_dependency("tailwindcss-ruby", [">= 4.0.0"])

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
