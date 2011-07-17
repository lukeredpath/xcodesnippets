require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "SnippetManager" do
  
  before(:each) do
    @manager = XcodeSnippets::SnippetManager.new(SNIPPETS_PATH, FakeUUIDGenerator)
    @manager.xcode_snippets_path = XCODE_SNIPPET_PATH
  end
  
  it "saves it's manifest to disk" do
    @manager.save_manifest
    File.exist?(File.join(SNIPPETS_PATH, "Manifest.plist")).should be_true
  end
  
  it "loads its manifest from disk on creation" do
    snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
    xcode_snippet_path = File.join(XCODE_SNIPPET_PATH, "#{FakeUUIDGenerator.generate}.codesnippet")
    snippet = @manager.install_snippet(snippet_path)
    new_manager = XcodeSnippets::SnippetManager.new(SNIPPETS_PATH, FakeUUIDGenerator)
    new_manager.manifest.should have_snippet(snippet)
  end

  describe "#install_snippet" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = @manager.install_snippet(snippet_path)
    end
    
    it "copies the specified snippet file to it's snippets dir in the default bundle" do
      expected_path = File.join(SNIPPETS_PATH, "Default.snippetbundle", "example.codesnippet")
      File.exist?(expected_path).should be_true
    end
    
    it "creates a GUID symlink to the installed snippet in the Xcode snippets directory" do
      symlink = @manager.manifest.symlink_for_snippet(@snippet)
      File.exist?(symlink).should be_true
    end
    
    it "updates it's manifest of installed and activated files" do
      xcode_snippet_path = File.join(XCODE_SNIPPET_PATH, "#{FakeUUIDGenerator.generate}.codesnippet")
      @manager.manifest.should have_snippet(@snippet)
    end
    
  end
  
  describe "#install_snippets" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippets = @manager.install_snippets([snippet_path])
    end
    
    it "returns an array of all installed snippets" do
      @snippets.should have(1).item
      @snippets.first.should exist
    end
    
  end
  
  describe "#uninstall_snippet" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = @manager.install_snippet(snippet_path)
      @symlink = @snippet.symlinked_path
      @manager.uninstall_snippet("example")
    end
    
    it "removes the snippet file from the default bundle" do
      @snippet.should_not exist
    end
    
    it "removes it's GUID symlink from the Xcode snippets directory" do
      File.exist?(@symlink).should be_false
    end
    
    it "removes the snippet from the manifest" do
      @manager.manifest.should_not have_snippet(@snippet)
    end
    
  end
  
end
