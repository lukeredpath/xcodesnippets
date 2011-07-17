require 'clamp/command'
require 'xcode_snippets/snippet_manager'

module XcodeSnippets
  class Main < Clamp::Command

    subcommand "install", "Install a snippet or snippet bundle" do
      parameter "FILE ...", "Path to code snippet to install"
      
      def execute
        file_list.each do |file|
          manager.install_snippet(file)
        end
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
