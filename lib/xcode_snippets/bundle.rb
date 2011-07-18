require 'xcode_snippets/snippet'

module XcodeSnippets
  class Bundle
    attr_reader :path, :snippets
    
    def initialize(path)
      @path = path
      @snippets = []
      load_snippets
    end
    
    class << self
      def bundle_named(name, install_directory)
        new(File.join(install_directory, "#{name}.snippetbundle"))
      end
    
      def default(directory)
        bundle = bundle_named("Default", directory)
        
        if bundle.exists?
          bundle
        else
          bundle.copy_to(directory)
        end
      end
    end
    
    def copy_to(directory)
      installation_path = File.join(directory, name)
      FileUtils.mkdir_p(installation_path)
      
      self.class.new(installation_path).tap do |copied_bundle|
        snippets.each do |snippet|
          copied_bundle.add_copy_of_snippet(snippet)
        end
      end
    end
    
    def name
      File.basename(path)
    end
    
    def exists?
      File.exist?(path)
    end
    
    def add_copy_of_snippet_from_file(snippet_path)
      add_copy_of_snippet Snippet.new(snippet_path)
    end
    
    def add_snippet(snippet)
      @snippets << snippet
      @snippets.last
    end
    
    def add_copy_of_snippet(snippet)
      @snippets << snippet.copy_to_bundle(self)
      @snippets.last
    end
    
    def delete
      FileUtils.rm_rf(path)
    end
    
    def snippet_named(name)
      name += ".codesnippet" if name !~ /\.codesnippet$/
      snippet = Snippet.new(File.join(path, name), self)
      snippet.exists? ? snippet : nil
    end
    
    private
    
    def load_snippets
      Dir["#{path}/*.codesnippet"].each do |file|
        add_snippet Snippet.new(file, self)
      end
    end
  end
end
