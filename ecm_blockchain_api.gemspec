# frozen_string_literal: true

require_relative "lib/ecm_blockchain_api/version"

Gem::Specification.new do |spec|
  spec.name          = "ecm_blockchain_api"
  spec.version       = ECMBlockchain::VERSION
  spec.authors       = ["Wardy"]
  spec.email         = ["info@ecmsecure.com"]

  spec.summary       = "ECM Distributed Ledger & Blockchain API"
  spec.description   = "Connect and transact with your ECM certificate authority and distributed ledger network."
  spec.homepage      = "https://www.ecmsecure.com"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ecmsecure/ecm_blockchain_api"
  spec.metadata["changelog_uri"] = "https://github.com/ecmsecure/ecm_blockchain_api/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "httparty", "~> 0.18"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
