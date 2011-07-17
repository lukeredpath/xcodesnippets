require 'ostruct'

Given /^Xcode snippets are stored in "([^"]*)"$/ do |path|
  FileUtils.mkdir_p(path)
  configuration.xcode_snippet_path = path
end

Given /^installed snippets are stored in "([^"]*)"$/ do |path|
  FileUtils.mkdir_p(path)
  configuration.installed_snippet_path = path
end

Given /^I have the snippet file "([^"]*)"$/ do |path|
  File.open(path, "w") do |io|
    io.write File.read(File.join(File.dirname(__FILE__), *%w[.. support fixtures example.codesnippet]))
  end
end

When /^I run "([^"]*)"$/ do |command|
  XcodeSnippets::Runner.run(command)
end

Then /^the snippet file should be installed to "([^"]*)"$/ do |path|
  configuration.last_installed_snippet = path
  File.exists?(path).should be_true
end

Then /^the installed snippet file should be symlinked insite "([^"]*)"$/ do |dir|
  file = Dir["#{dir}/*.codesnippet"].find do |snippet|
    File.read(snippet) == File.read(configuration.last_installed_snippet)
  end
  
  file.should_not be_nil
  file.should be_symlink
end
