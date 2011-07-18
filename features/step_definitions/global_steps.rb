require 'ostruct'

Given /^Xcode snippets are stored in "([^"]*)"$/ do |path|
  FileUtils.mkdir_p(path)
  XcodeSnippets.xcode_snippets_path = File.expand_path(path)
end

Given /^installed snippets are stored in "([^"]*)"$/ do |path|
  FileUtils.mkdir_p(path)
  XcodeSnippets.installation_path = File.expand_path(path)
end

Given /^I have the snippet file "([^"]*)"$/ do |path|
  configuration.snippets ||= []
  configuration.snippets << File.basename(path)
  
  File.open(path, "w") do |io|
    io.write File.read(File.join(File.dirname(__FILE__), *%w[.. support fixtures example.codesnippet]))
  end
end

Given /^I have the snippet bundle "([^"]*)"$/ do |path|
  configuration.bundles ||= []
  configuration.bundles << path
  FileUtils.mkdir_p(path)
end

Given /^the bundle contains the snippet "([^"]*)"$/ do |snippet_name|
  current_bundle = configuration.bundles.last
  
  File.open(File.join(current_bundle, snippet_name), "w") do |io|
    io.write File.read(File.join(File.dirname(__FILE__), *%w[.. support fixtures example.codesnippet]))
  end
end

Given /^I have installed the snippet file "([^"]*)"$/ do |path|
  configuration.installed_snippet = XcodeSnippets::Runner.run("install #{path}").first
end

Given /^I have installed the snippet bundle "([^"]*)"$/ do |path|
  configuration.installed_bundle = XcodeSnippets::Runner.run("install-bundle #{path}")
end

Given /^I have the existing snippet "([^"]*)"$/ do |snippet_name|
  # we need a clean slate for deterministic tests
  Dir[File.join(XcodeSnippets.xcode_snippets_path, "*.codesnippet")].each do |file|
    FileUtils.rm_rf(file)
  end
  File.open(File.join(XcodeSnippets.xcode_snippets_path, snippet_name), "w") do |io|
    io.write File.read(File.join(File.dirname(__FILE__), *%w[.. support fixtures example.codesnippet]))
  end
end

When /^I run xcodesnippets with "([^"]*)"$/ do |command|
  configuration.last_result = XcodeSnippets::Runner.run(command)
  
  if configuration.last_result.is_a?(StandardError)
    raise configuration.last_result
  end
end

Then /^the snippet file should be installed to "([^"]*)"$/ do |path|
  if configuration.last_result.is_a?(XcodeSnippets::Bundle)
    installed_snippet = configuration.last_result.snippets.first
  else
    installed_snippet = configuration.last_result.first
  end
  installed_snippet.path.should == File.expand_path(path)
  installed_snippet.should exist
end

Then /^the snippet files should be installed to "([^"]*)"$/ do |root_path|
  if configuration.last_result.is_a?(XcodeSnippets::Bundle)
    snippets = configuration.last_result.snippets
  else
    snippets = configuration.last_result
  end
  
  snippets.each do |snippet|
    expected_path = File.join(File.expand_path(root_path), snippet.name)
    snippet.path.should == expected_path
    snippet.should exist
  end
end

Then /^the installed snippet files should be symlinked inside "([^"]*)"$/ do |dir|
  if configuration.last_result.is_a?(XcodeSnippets::Bundle)
    snippets = configuration.last_result.snippets
  else
    snippets = configuration.last_result
  end

  snippets.each do |snippet|
    File.dirname(snippet.symlink).should == File.expand_path(dir)
    snippet.should be_symlinked
  end
end

Then /^the snippet file "([^"]*)" should not exist$/ do |path|
  File.exist?(path).should be_false
end

Then /^it's symlink should be removed$/ do
  configuration.installed_snippet.should_not be_symlinked
end

Then /^the snippet bundle should not exist$/ do
  configuration.installed_bundle.should_not exist
end

Then /^all of the bundle snippet symlinks should be removed$/ do
  configuration.installed_bundle.snippets.each do |snippet|
    snippet.should_not be_symlinked
  end
end
