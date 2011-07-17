require 'clamp/command'
require 'xcode_snippets/snippet_manager'

module XcodeSnippets
  class Main < Clamp::Command

    subcommand "install", "Install a snippet or snippet bundle" do
      parameter "FILE ...", "Path to code snippet to install"
      
      def execute
        manager.install_snippets(file_list)
      end
    end
    
    subcommand "uninstall", "Uninstall a snippet or snippet bundle" do
      parameter "NAME", "Name of the installed snippet"
      
      def execute
        manager.uninstall_snippet(name)
      end
    end
    
    private
    
    def manager
      XcodeSnippets::SnippetManager.new(installation_path).tap do |manager|
        manager.xcode_snippets_path = XcodeSnippets.xcode_snippets_path
      end
    end
    
    def installation_path
      XcodeSnippets.installation_path
    end

  end
end
