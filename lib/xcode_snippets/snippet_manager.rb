require 'uuidtools'
require 'xcode_snippets/bundle'
require 'xcode_snippets/manifest'

module XcodeSnippets
  class SnippetManager
    attr_reader :manifest
    
    def initialize(manifest)
      @manifest = manifest
    end
    
    def install_snippet_from_path(path_to_snippet)
      install_snippet default_bundle.add_copy_of_snippet_from_file(path_to_snippet)
    end
    
    def install_snippets_from_paths(snippet_path_list)
      snippets = snippet_path_list.map do |path_to_snippet|
        default_bundle.add_copy_of_snippet_from_file(path_to_snippet)
      end
      install_snippets snippets
    end
    
    def install_snippet(snippet)
      snippet.activate(manifest)
      save_manifest
      snippet
    end
    
    def install_snippets(snippets)
      snippets.each { |snippet| snippet.activate(manifest) }
      save_manifest
      snippets
    end
    
    def uninstall_snippet_named(snippet_name)
      if snippet = default_bundle.snippet_named(snippet_name)
        snippet.deactivate(manifest)
        snippet.uninstall
        save_manifest
      end
    end
    
    def install_snippet_bundle(path_to_bundle)
      Bundle.new(path_to_bundle).copy_to(manifest.snippets_install_path).tap do |bundle|
        install_snippets(bundle.snippets)
      end
    end
    
    def save_manifest
      manifest.save
    end
    
    private
    
    def default_bundle
      Bundle.default(manifest.snippets_install_path)
    end
  end
end
