# frozen_string_literal: true

require_relative "lib/stackprof/route_middleware/version"

Gem::Specification.new do |spec|
  spec.name = "stackprof-route_middleware"
  spec.version = StackProf::RouteMiddleware::VERSION
  spec.authors = ["Yusuke Sangenya"]
  spec.email = ["longinus.eva@gmail.com"]

  spec.summary = "Rack middleware to profile each route using StackProf"
  spec.homepage = "https://github.com/genya0407/stackprof-route_middleware"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/genya0407/stackprof-route_middleware"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "stackprof"
end
