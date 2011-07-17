require 'uuidtools'
require 'plist'

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
      default_bundle_path = File.join(@snippets_install_path, "Default.snippetbundle")
      FileUtils.mkdir_p(default_bundle_path)
      FileUtils.cp(path_to_snippet, default_bundle_path)
      snippet_file_name = File.basename(path_to_snippet)
      installed_path = File.join(default_bundle_path, snippet_file_name)
      symlinked_path = File.join(xcode_snippets_path, "#{generate_uuid}.codesnippet")
      FileUtils.symlink(installed_path, symlinked_path)
      @manifest["Default.snippetbundle/#{snippet_file_name}"] = symlinked_path
      save_manifest_to_disk
    end
    
    def save_manifest_to_disk
      File.open(File.join(@snippets_install_path, "Manifest.plist"), "w") do |io|
        io.write manifest.to_plist
      end
    end
    
    private
    
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
