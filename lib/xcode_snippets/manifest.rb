require 'plist'

module XcodeSnippets
  class Manifest
    attr_reader :snippets_install_path
    
    def initialize(snippets_install_path, xcode_snippets_install_path, uuid_generator = UUIDGenerator)
      @snippets_install_path = snippets_install_path
      @xcode_snippets_install_path = xcode_snippets_install_path
      @uuid_generator = uuid_generator
      @data = {}
    end
    
    def self.load(snippets_install_path, xcode_snippets_install_path, uuid_generator = UUIDGenerator)
      new(snippets_install_path, xcode_snippets_install_path, uuid_generator).tap { |manifest| manifest.load }
    end
    
    def add_snippet(snippet)
      @data[snippet.key] = snippet.symlink
    end
    
    def add_snippet!(snippet)
      add_snippet(snippet)
      save
    end
    
    def remove_snippet(snippet)
      @data.delete(snippet.key)
    end
    
    def remove_snippet!(snippet)
      remove_snippet(snippet)
      save
    end
    
    def has_snippet?(snippet)
      @data[snippet.key] && @data[snippet.key] == snippet.symlink
    end
    
    def save
      File.open(path, "w") do |io|
        io.write @data.to_plist
      end
    end
    
    def load
      @data = Plist.parse_xml(path) || {}
    end
    
    def symlink_for_snippet(snippet)
      @data[snippet.key]
    end
    
    def generate_new_symlink
      File.join(@xcode_snippets_install_path, "#{@uuid_generator.generate}.codesnippet")
    end
    
    private
    
    def path
      File.join(@snippets_install_path, "Manifest.plist")
    end
    
    class UUIDGenerator
      def self.generate
        UUIDTools::UUID.random_create.to_s.upcase
      end
    end
  end
end
