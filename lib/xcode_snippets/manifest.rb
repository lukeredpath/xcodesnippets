require 'plist'

module XcodeSnippets
  class Manifest
    def initialize(snippets_install_path)
      @snippets_install_path = snippets_install_path
      @data = {}
    end
    
    def self.load(path)
      new(path).tap { |manifest| manifest.load }
    end
    
    def add_snippet(snippet)
      @data[snippet.key] = snippet.symlinked_path
    end
    
    def add_snippet!(snippet)
      add_snippet(snippet)
      save
    end
    
    def has_snippet?(snippet)
      @data[snippet.key] && @data[snippet.key] == snippet.symlinked_path
    end
    
    def save
      File.open(path, "w") do |io|
        io.write @data.to_plist
      end
    end
    
    def load
      @data = Plist.parse_xml(path) || {}
    end
    
    private
    
    def path
      File.join(@snippets_install_path, "Manifest.plist")
    end
  end
end
