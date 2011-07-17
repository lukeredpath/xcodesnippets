require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "SnippetManager" do
  
  before(:each) do
    @manager = XcodeSnippets::SnippetManager.new(SNIPPETS_PATH, FakeUUIDGenerator)
    @manager.xcode_snippets_path = XCODE_SNIPPET_PATH
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
    
  end
  
end
