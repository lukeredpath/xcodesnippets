require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "SnippetManager" do
  
  before(:each) do
    @manager = XcodeSnippets::SnippetManager.new(SNIPPETS_PATH, FakeUUIDGenerator)
    @manager.xcode_snippets_path = XCODE_SNIPPET_PATH
  end
  
  it "saves it's manifest to disk" do
    @manager.save_manifest_to_disk
    File.exist?(File.join(SNIPPETS_PATH, "Manifest.plist")).should be_true
  end
  
  it "loads its manifest from disk on creation" do
    snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
    xcode_snippet_path = File.join(XCODE_SNIPPET_PATH, "#{FakeUUIDGenerator.generate}.codesnippet")
    @manager.install_snippet(snippet_path)
    new_manager = XcodeSnippets::SnippetManager.new(SNIPPETS_PATH, FakeUUIDGenerator)
    new_manager.manifest.should include("Default.snippetbundle/example.codesnippet" => xcode_snippet_path)
  end

  context "#install_snippet" do
    
    before do
      snippet_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @manager.install_snippet(snippet_path)
    end
    
    it "copies the specified snippet file to it's snippets dir in the default bundle" do
      expected_path = File.join(SNIPPETS_PATH, "Default.snippetbundle", "example.codesnippet")
      File.exist?(expected_path).should be_true
    end
    
    it "creates a GUID symlink to the installed snippet in the Xcode snippets directory" do
      expected_path = File.join(XCODE_SNIPPET_PATH, "#{FakeUUIDGenerator.generate}.codesnippet")
      File.exist?(expected_path).should be_true
      File.symlink?(expected_path).should be_true
    end
    
    it "updates it's manifest of installed and activated files" do
      xcode_snippet_path = File.join(XCODE_SNIPPET_PATH, "#{FakeUUIDGenerator.generate}.codesnippet")
      @manager.manifest.should include("Default.snippetbundle/example.codesnippet" => xcode_snippet_path)
    end
    
  end
  
end
