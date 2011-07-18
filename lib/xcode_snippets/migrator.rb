module XcodeSnippets
  class Migrator
    def initialize(snippet_manager)
      @snippet_manager = snippet_manager
    end
    
    def migrate_snippets_from(path, confirmation_delegate = nil)
      make_temp_dir(path)
      snippet_files = Dir[File.join(path, "*.codesnippet")]
      
      snippets = snippet_files.map do |snippet_path|
        XcodeSnippets::Snippet.new(snippet_path)
      end
      
      if confirmation_delegate && confirmation_delegate.respond_to?(:migrator_should_proceed_with_migration?)
        return unless confirmation_delegate.migrator_should_proceed_with_migration?(self, snippets)
      end
      
      temp_paths = snippets.map do |snippet|
        File.join(@tmp_dir, "#{snippet.metadata.title}.codesnippet").tap do |temp_path|
          FileUtils.mv(snippet.path, temp_path)
        end
      end
      
      @snippet_manager.install_snippets_from_paths(temp_paths)
    end
    
    def clean_up
      FileUtils.rm_rf(@tmp_dir) if @tmp_dir
      @tmp_dir = nil
    end
    
    private
    
    def make_temp_dir(path)
      unless @tmp_dir
        @tmp_dir = File.join(path, "migrator")
        FileUtils.mkdir_p(@tmp_dir)
      end
    end
  end
end
