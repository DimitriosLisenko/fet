# frozen_string_literal: true

require_relative "lib/fet/version"

Gem::Specification.new do |spec|
  spec.name          = "fet"
  spec.version       = Fet::VERSION
  spec.authors       = ["Dimitrios Lisenko"]
  spec.email         = ["dimitrioslisenko@gmail.com"]

  spec.summary       = "A functional ear trainer."
  spec.description   = "Teaches your ear to recognize notes based on their function in a key."
  spec.homepage      = "https://github.com/DimitriosLisenko/fet"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/DimitriosLisenko/fet"
  spec.metadata["changelog_uri"] = "https://github.com/DimitriosLisenko/fet/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "bin"
  spec.executables << "fet"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Gem runtime dependencies - place development dependencies inside Gemfile
  spec.add_dependency "gli", "~> 2.20", ">= 2.20.1"
  spec.add_dependency "ice_nine", "~> 0.11.2"
  spec.add_dependency "midilib", "~> 2.0", ">= 2.0.5"

  # RDoc configuration
  spec.extra_rdoc_files = ["README.rdoc", "fet.rdoc"]
  spec.rdoc_options << "--title" << "fet" << "--main" << "README.rdoc" << "-ri"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
