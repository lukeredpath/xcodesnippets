require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "Migrator" do
  
  before do
    @manager  = mock("manager")
    @migrator = XcodeSnippets::Migrator.new(@manager)
    create_example_xcode_snippets_directory
  end
  
  context "migrating existing snippets" do
    
    it "copies each snippet to a temporary directory with a filename that reflects the snippet name" do
      @manager.stub(:install_snippets_from_paths)
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH)
      file_at(temporary_snippet_path_for("appledoc class.codesnippet")).should exist
    end
    
    it "removes the original snippet" do
      @manager.stub(:install_snippets_from_paths)
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH)
      file_at(xcode_snippet_path).should_not exist
    end
    
    it "installs each snippet from it's temporary location" do
      @manager.should_receive(:install_snippets_from_paths).with([temporary_snippet_path_for("appledoc class.codesnippet")])
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH)
    end
    
    it "returns the created snippets" do
      @manager.stub(:install_snippets_from_paths).and_return(["snippet"])
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH).should == ["snippet"]
    end
    
  end
  
  context "migrating with a confirmation delegate" do
    
    before do
      @delegate = stub("confirmation-delegate")
    end
    
    it "migrates the snippets if the confirmation delegate returns true" do
      @delegate.stub(:migrator_should_proceed_with_migration?).and_return(true)
      @manager.should_receive(:install_snippets_from_paths)
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH, @delegate)
    end
    
    it "migrates the snippets if the confirmation delegate returns false" do
      @delegate.stub(:migrator_should_proceed_with_migration?).and_return(false)
      @manager.should_receive(:install_snippets_from_paths).never
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH, @delegate)
    end
    
  end
  
  context "cleaning up after migration" do
    
    before do
      @manager.stub(:install_snippets_from_paths)
      @migrator.migrate_snippets_from(XCODE_SNIPPET_PATH)
    end
    
    it "removes the temporary migrator directory" do
      @migrator.clean_up
      directory(File.join(XCODE_SNIPPET_PATH, "migrator")).should_not exist
    end
    
  end
  
  private
  
  def create_example_xcode_snippets_directory
    FileUtils.cp(example_snippet_path, xcode_snippet_path)
  end
  
  def temporary_snippet_path_for(name)
    File.join(XCODE_SNIPPET_PATH, "migrator", name)
  end
  
  def example_snippet_path
    File.join(FIXTURES_PATH, "example.codesnippet")
  end
  
  def xcode_snippet_path
    @guid ||= UUIDTools::UUID.timestamp_create
    File.join(XCODE_SNIPPET_PATH, "#{@guid}.codesnippet")
  end
  
end
