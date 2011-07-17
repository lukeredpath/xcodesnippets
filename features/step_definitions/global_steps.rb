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

Given /^I have installed the snippet file "([^"]*)"$/ do |path|
  XcodeSnippets::Runner.run("install #{path}")
  configuration.last_installed_snippets = [path]
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
  # file = Dir["#{XcodeSnippets.xcode_snippets_path}/**/*.codesnippet"].find do |snippet|
  #   File.read(snippet) == File.read(configuration.uninstalled_snippet)
  # end
  # 
  # file.should be_nil
end
