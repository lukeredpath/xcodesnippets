require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require File.join(File.dirname(__FILE__), *%w[lib xcode_snippets/version])

Cucumber::Rake::Task.new(:features)

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--color"
end

task :default => [:spec, :features]

require "rubygems"
require "rubygems/package_task"

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "xcodesnippets"
  s.version           = XcodeSnippets::Version.to_s
  s.summary           = "A command-line utility for managing Xcode 4 code snippets"
  s.author            = "Luke Redpath"
  s.email             = "luke@lukeredpath.co.uk"
  s.homepage          = "http://lukeredpath.co.uk"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.md)
  s.rdoc_options      = %w(--main README.md)

  # Add any extra files to include in the gem
  s.files             = %w(LICENSE README.md) + Dir.glob("{bin,spec,lib}/**/*")
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  s.add_dependency("clamp",     "~> 0.2.1")
  s.add_dependency("uuidtools", "~> 2.1.2")
  s.add_dependency("plist",     "~> 3.1.0")
  s.add_dependency("highline",  "~> 1.6.2")

  # If your tests use any gems, include them here
  s.add_development_dependency("rspec")
  s.add_development_dependency("cucumber")
  # s.add_development_dependency("ruby-debug19")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more 
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

desc "Update bundled gems"
task :bundle => :gemspec do
  system "bundle"
end

# If you don't want to generate the .gemspec file, just remove this line. Reasons
# why you might want to generate a gemspec:
#  - using bundler with a git source
#  - building the gem without rake (i.e. gem build blah.gemspec)
#  - maybe others?
task :package => :gemspec

desc "Build and deploy the gem to RubyGems.org"
task :release => :package do
  gem_path = File.join('pkg', spec.file_name)
  system "gem push #{gem_path}"
end
