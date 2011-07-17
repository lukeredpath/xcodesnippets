require 'uuidtools'

module XcodeSnippets
  class SnippetManager
    attr_accessor :xcode_snippets_path
    attr_reader :manifest
    
    def initialize(snippets_install_path, uuid_generator = UUIDGenerator)
      @snippets_install_path = snippets_install_path
      @uuid_generator = uuid_generator
      @xcode_snippets_path = XcodeSnippets::DEFAULT_XCODE_SNIPPETS_PATH
      @manifest = {}
    end
    
    def install_snippet(path_to_snippet)
      default_bundle_path = File.join(@snippets_install_path, "Default.snippetbundle")
      FileUtils.mkdir_p(default_bundle_path)
      FileUtils.cp(path_to_snippet, default_bundle_path)
      snippet_file_name = File.basename(path_to_snippet)
      installed_path = File.join(default_bundle_path, snippet_file_name)
      symlinked_path = File.join(xcode_snippets_path, "#{generate_uuid}.codesnippet")
      FileUtils.symlink(installed_path, symlinked_path)
      @manifest["Default.snippetbundle/#{snippet_file_name}"] = symlinked_path
    end
    
    private
    
    def generate_uuid
      @uuid_generator.generate
    end
  end
  
  class UUIDGenerator
    def self.generate
      UUIDTools::UUID.random_create.to_s.upcase
    end
  end
end
