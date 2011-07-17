require 'uuidtools'
require 'plist'
require 'xcode_snippets/bundle'

module XcodeSnippets
  class SnippetManager
    attr_accessor :xcode_snippets_path
    attr_reader :manifest
    
    def initialize(snippets_install_path, uuid_generator = UUIDGenerator)
      @snippets_install_path = snippets_install_path
      @uuid_generator = uuid_generator
      @xcode_snippets_path = XcodeSnippets::DEFAULT_XCODE_SNIPPETS_PATH
      @manifest = load_manifest_from_disk || {}
    end
    
    def install_snippet(path_to_snippet)
      snippet = Bundle.default(@snippets_install_path).add_snippet_from_file(path_to_snippet)
      snippet.activate!(generate_uuid, @xcode_snippets_path)
      update_manifest(snippet.key, snippet.symlinked_path)
    end
    
    def save_manifest_to_disk
      File.open(File.join(@snippets_install_path, "Manifest.plist"), "w") do |io|
        io.write manifest.to_plist
      end
    end
    
    private
    
    def update_manifest(key, value)
      @manifest[key] = value
      save_manifest_to_disk
    end
    
    def generate_uuid
      @uuid_generator.generate
    end
    
    def load_manifest_from_disk
      manifest_path = File.join(@snippets_install_path, "Manifest.plist")
      
      if File.exist?(manifest_path)
        Plist.parse_xml(manifest_path)
      else
        nil
      end
    end
  end
  
  class UUIDGenerator
    def self.generate
      UUIDTools::UUID.random_create.to_s.upcase
    end
  end
end
