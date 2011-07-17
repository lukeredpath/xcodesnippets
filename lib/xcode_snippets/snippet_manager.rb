require 'uuidtools'
require 'xcode_snippets/bundle'
require 'xcode_snippets/manifest'

module XcodeSnippets
  class SnippetManager
    attr_accessor :xcode_snippets_path
    attr_reader :manifest
    
    def initialize(snippets_install_path, uuid_generator = UUIDGenerator)
      @snippets_install_path = snippets_install_path
      @uuid_generator = uuid_generator
      @xcode_snippets_path = XcodeSnippets::DEFAULT_XCODE_SNIPPETS_PATH
      @manifest = Manifest.load(snippets_install_path)
    end
    
    def install_snippet(path_to_snippet, update_manifest = true)
      snippet = default_bundle.add_snippet_from_file(path_to_snippet)
      snippet.activate(generate_uuid, @xcode_snippets_path)
      manifest.add_snippet!(snippet) if update_manifest
      snippet
    end
    
    def install_snippets(snippet_path_list)
      snippets = snippet_path_list.map do |path_to_snippet|
        snippet = install_snippet(path_to_snippet, false)
        manifest.add_snippet(snippet)
        snippet
      end
      manifest.save
      snippets
    end
    
    def uninstall_snippet(snippet_name)
      if snippet = default_bundle.snippet_named(snippet_name)
        snippet.uninstall
        manifest.remove_snippet!(snippet)
      end
    end
    
    def save_manifest
      manifest.save
    end
    
    private
    
    def generate_uuid
      @uuid_generator.generate
    end
    
    def default_bundle
      Bundle.default(@snippets_install_path)
    end
    
    class UUIDGenerator
      def self.generate
        UUIDTools::UUID.random_create.to_s.upcase
      end
    end
  end
end
