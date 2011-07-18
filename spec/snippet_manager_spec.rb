require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "SnippetManager" do
  
  before(:each) do
    manifest = XcodeSnippets::Manifest.load(SNIPPETS_PATH, XCODE_SNIPPET_PATH, FakeUUIDGenerator)
    @manager = XcodeSnippets::SnippetManager.new(manifest)
  end
  
  it "saves it's manifest to disk" do
    @manager.save_manifest
    File.exist?(File.join(SNIPPETS_PATH, "Manifest.plist")).should be_true
  end

  describe "#install_snippet_from_path" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = @manager.install_snippet_from_path(snippet_path)
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
      @manager.manifest.should have_snippet(@snippet)
    end
    
  end
  
  describe "#install_snippets_from_paths" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippets = @manager.install_snippets_from_paths([snippet_path])
    end
    
    it "returns an array of all installed snippets" do
      @snippets.should have(1).item
      @snippets.first.should exist
    end
    
  end
  
  describe "#uninstall_snippet_named" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = @manager.install_snippet_from_path(snippet_path)
      @symlink = @snippet.symlink
      @manager.uninstall_snippet_named("example")
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
  
  describe "#install_snippet_bundle" do
    
    before do
      bundle_path = File.join(FIXTURES_PATH, "Example.snippetbundle")      
      @bundle = @manager.install_snippet_bundle(bundle_path)
    end
    
    it "creates the snippet bundle in the snippets directory" do
      expected_path = File.join(SNIPPETS_PATH, "Example.snippetbundle")
      File.directory?(expected_path).should be_true
    end
    
    it "copies all of the bundle's snippets to it's installed location" do
      expected_path = File.join(SNIPPETS_PATH, "Example.snippetbundle", "snippet-one.codesnippet")
      File.exist?(expected_path).should be_true
    end
    
    it "creates a GUID symlink for each bundle snippet in the Xcode snippets directory" do
      @bundle.snippets.each do |snippet|
        symlink = @manager.manifest.symlink_for_snippet(snippet)
        File.exist?(symlink).should be_true
      end      
    end
    
    it "updates it's manifest of installed and activated files" do
      @bundle.snippets.each do |snippet|
        @manager.manifest.should have_snippet(snippet)
      end
    end
    
  end
  
  describe "#uninstall_snippet_bundle_named" do
    
    before do
      bundle_path = File.join(FIXTURES_PATH, "Example.snippetbundle")      
      @bundle = @manager.install_snippet_bundle(bundle_path)
      @manager.uninstall_snippet_bundle_named("Example")
    end
    
    it "removes the snippet bundle from the install path" do
      @bundle.should_not exist
    end
    
  end
  
end
