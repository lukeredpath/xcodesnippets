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

When /^I run xcodesnippets with "([^"]*)"$/ do |command|
  XcodeSnippets::Runner.run(command)
end

Then /^the snippet file should be installed to "([^"]*)"$/ do |path|
  File.exists?(path).should be_true
  configuration.last_installed_snippets = [path]
end

Then /^the snippet files should be installed to "([^"]*)"$/ do |root_path|
  installed = []
  
  configuration.snippets.each do |snippet|
    path = File.join(root_path, snippet)
    File.exists?(path).should be_true
    installed << path
  end
  
  configuration.last_installed_snippets = installed
end

Then /^the installed snippet files should be symlinked inside "([^"]*)"$/ do |dir|
  configuration.last_installed_snippets.each do |installed_snippet|
    file = Dir["#{dir}/**/*.codesnippet"].find do |snippet|
      File.read(snippet) == File.read(installed_snippet)
    end

    file.should_not be_nil
    File.symlink?(file).should be_true
  end
end

Then /^the snippet file "([^"]*)" should not exist$/ do |path|
  File.exist?(path).should be_false
  configuration.uninstalled_snippet = path
end

Then /^it's symlink should be removed$/ do
  File.exist?(configuration.installed_snippet.symlink).should be_false
end
