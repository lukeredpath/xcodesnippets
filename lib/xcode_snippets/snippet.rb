module XcodeSnippets
  class Snippet
    attr_reader :path, :symlinked_path
    
    def initialize(bundle, path)
      @bundle = bundle
      @path = path
    end
    
    def activate!(uuid, xcode_snippets_path)
      @symlinked_path = File.join(xcode_snippets_path, "#{uuid}.codesnippet")
      FileUtils.symlink(path, @symlinked_path)
    end
    
    def name
      File.basename(@path)
    end
    
    def key
      "#{@bundle.name}/#{name}"
    end
  end
end
