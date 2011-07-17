$:.unshift(File.dirname(__FILE__))

require 'fileutils'
require 'xcode_snippets/main'

module XcodeSnippets
  DEFAULT_INSTALLATION_PATH   = File.expand_path("~/Library/Developer/Xcode/UserData/ManagedCodeSnippets")
  DEFAULT_XCODE_SNIPPETS_PATH = File.expand_path("~/Library/Developer/Xcode/UserData/CodeSnippets")
  
  def self.installation_path
    @installation_path || DEFAULT_INSTALLATION_PATH
  end
  
  def self.installation_path=(path)
    @installation_path = path
  end
  
  def self.xcode_snippets_path
    @xcode_snippets_path || DEFAULT_XCODE_SNIPPETS_PATH
  end
  
  def self.xcode_snippets_path=(path)
    @xcode_snippets_path = path
  end
end
