module XcodeSnippets
  class Snippet
    attr_reader :path, :symlink
    
    def initialize(path, bundle = nil)
      @path = path
      @bundle = bundle
    end
    
    def copy_to_bundle(bundle)
      FileUtils.cp(path, bundle.path)
      self.class.new(File.join(bundle.path, name), bundle)
    end
    
    def activate(manifest)
      @symlink = manifest.generate_new_symlink
      FileUtils.symlink(path, symlink)
      manifest.add_snippet(self)
    end
    
    def deactivate(manifest)
      manifest.remove_snippet(self)
    end
    
    def uninstall
      FileUtils.rm_f(path)
    end
    
    def name
      File.basename(@path)
    end
    
    def key
      @bundle ? "#{@bundle.name}/#{name}" : name
    end
    
    def exists?
      File.exist?(path)
    end
  end
end
