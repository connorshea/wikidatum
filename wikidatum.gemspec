# frozen_string_literal: true

require_relative "lib/wikidatum/version"

Gem::Specification.new do |spec|
  spec.name = "wikidatum"
  spec.version = Wikidatum::VERSION
  spec.authors = ["Connor Shea"]
  spec.email = ["connor.james.shea+rubygems@gmail.com"]

  spec.summary = "Ruby gem for the new Wikidata REST API."
  spec.description = "Interact with the Wikidata/Wikibase REST API from Ruby."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = "https://github.com/connorshea/wikidatum"
  spec.metadata["source_code_uri"] = "https://github.com/connorshea/wikidatum"
  spec.metadata["changelog_uri"] = "https://github.com/connorshea/wikidatum/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|))})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
