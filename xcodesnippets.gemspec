# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{xcodesnippets}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luke Redpath"]
  s.date = %q{2011-07-18}
  s.default_executable = %q{xcodesnippets}
  s.email = %q{luke@lukeredpath.co.uk}
  s.executables = ["xcodesnippets"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["LICENSE", "README.md", "bin/xcodesnippets", "spec/bundle_spec.rb", "spec/migrator_spec.rb", "spec/snippet_manager_spec.rb", "spec/spec_helper.rb", "lib/xcode_snippets", "lib/xcode_snippets/bundle.rb", "lib/xcode_snippets/main.rb", "lib/xcode_snippets/manifest.rb", "lib/xcode_snippets/migrator.rb", "lib/xcode_snippets/snippet.rb", "lib/xcode_snippets/snippet_manager.rb", "lib/xcode_snippets/version.rb", "lib/xcode_snippets.rb"]
  s.homepage = %q{http://lukeredpath.co.uk}
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A command-line utility for managing Xcode 4 code snippets}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<clamp>, ["~> 0.2.1"])
      s.add_runtime_dependency(%q<uuidtools>, ["~> 2.1.2"])
      s.add_runtime_dependency(%q<plist>, ["~> 3.1.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_development_dependency(%q<highline>, [">= 0"])
    else
      s.add_dependency(%q<clamp>, ["~> 0.2.1"])
      s.add_dependency(%q<uuidtools>, ["~> 2.1.2"])
      s.add_dependency(%q<plist>, ["~> 3.1.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_dependency(%q<highline>, [">= 0"])
    end
  else
    s.add_dependency(%q<clamp>, ["~> 0.2.1"])
    s.add_dependency(%q<uuidtools>, ["~> 2.1.2"])
    s.add_dependency(%q<plist>, ["~> 3.1.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
    s.add_dependency(%q<highline>, [">= 0"])
  end
end
