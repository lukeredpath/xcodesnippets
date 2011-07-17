require 'xcode_snippets/snippet'

module XcodeSnippets
  class Bundle
    attr_reader :path
    
    def initialize(path)
      @path = path
      @snippets = []
      FileUtils.mkdir_p(@path)
    end
    
    def name
      File.basename(path)
    end
    
    def self.named(name, root_path)
      new(File.join(root_path, "#{name}.snippetbundle"))
    end
    
    def self.default(root_path)
      named("Default", root_path)
    end
    
    def add_snippet_from_file(snippet_path)
      FileUtils.cp(snippet_path, path)
      add_snippet Snippet.new(self, File.join(path, File.basename(snippet_path)))
    end
    
    def add_snippet(snippet)
      @snippets << snippet
      snippet
    end
  end
end
