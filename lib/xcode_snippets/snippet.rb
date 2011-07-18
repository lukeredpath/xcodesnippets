module XcodeSnippets
  class Snippet
    attr_reader :path, :symlink
    
    def initialize(path, bundle = nil)
      @path = path
      @bundle = bundle
    end
    
    def set_guid!(new_guid)
      metadata.guid = new_guid
      metadata.save_to(path)
    end
    
    def copy_to_bundle(bundle)
      FileUtils.cp(path, bundle.path)
      self.class.new(File.join(bundle.path, name), bundle)
    end
    
    def activate(manifest)
      @symlink = manifest.generate_symlink_for_snippet(self)
      FileUtils.symlink(path, symlink)
      manifest.add_snippet(self)
    end
    
    def deactivate(manifest)
      manifest.remove_snippet(self)
    end
    
    def delete
      FileUtils.rm_f(path)
    end
    
    def name
      File.basename(@path)
    end
    
    def guid
      metadata.guid
    end
    
    def metadata
      @metadata ||= MetaData.from_file(path)
    end
    
    def key
      @bundle ? "#{@bundle.name}/#{name}" : name
    end
    
    def exists?
      File.exist?(path)
    end
    
    def symlinked?
      symlink && File.exist?(symlink)
    end
    
    class MetaData
      def initialize(data)
        @data = data
      end
      
      def self.from_file(path)
        raise "Could not parse metadata in file #{path}" unless File.exist?(path)
        new(Plist.parse_xml(path))
      end
      
      def title
        @data["IDECodeSnippetTitle"]
      end
      
      def guid
        @data["IDECodeSnippetIdentifier"]
      end
      
      def guid=(new_guid)
        @data["IDECodeSnippetIdentifier"] = new_guid
      end
      
      def save_to(path)
        File.open(path, "w") do |io|
          io.write @data.to_plist
        end
      end
    end
  end
end
