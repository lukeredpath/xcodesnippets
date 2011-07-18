require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "A bundle" do
  
  before do
    example_bundle_path = File.join(FIXTURES_PATH, "Example.snippetbundle")
    @bundle = XcodeSnippets::Bundle.new(example_bundle_path)
  end
  
  it "has a name" do
    @bundle.name.should == "Example.snippetbundle"
  end
  
  it "has a snippet for each codesnippet file in the bundle" do
    @bundle.should have(2).snippets
    @bundle.snippets[0].name.should == "snippet-one.codesnippet"
    @bundle.snippets[1].name.should == "snippet-two.codesnippet"
  end
  
  context "adding a snippet" do
    
    before do
      example_snippet = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = XcodeSnippets::Snippet.new(example_snippet)
      @bundle.add_snippet(@snippet)
    end
    
    it "should increase the number of snippets in the bundle" do
      @bundle.should have(3).snippets
    end
    
    it "should not change the path of the snippet" do
      @bundle.snippets.last.path.should == @snippet.path
    end
    
  end
  
  context "adding a copy of a snippet" do
    
    before do
      example_snippet = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = XcodeSnippets::Snippet.new(example_snippet)
      @bundle.add_copy_of_snippet(@snippet)
    end
    
    after do
      if @bundle.snippets.last.name == "example.codesnippet"
        FileUtils.rm(@bundle.snippets.last.path)
      end
    end
    
    it "should increase the number of snippets in the bundle" do
      @bundle.should have(3).snippets
    end
    
    it "should copy the snippet into the bundle's directory" do
      @bundle.snippets.last.path.should_not == @snippet.path
      @bundle.snippets.last.path.should == File.join(@bundle.path, @snippet.name)
      @bundle.snippets.last.should exist
    end
    
  end
  
  context "adding a copy of a snippet from a file" do
    
    before do
      snippet_file_path = File.join(FIXTURES_PATH, "example.codesnippet")
      @snippet = @bundle.add_copy_of_snippet_from_file(snippet_file_path)
    end
    
    after do
      if @bundle.snippets.last.name == "example.codesnippet"
        FileUtils.rm(@bundle.snippets.last.path)
      end
    end
    
    it "should increase the number of snippets in the bundle" do
      @bundle.should have(3).snippets
    end
    
    it "should copy the snippet into the bundle's directory" do
      @snippet.path.should == File.join(@bundle.path, @snippet.name)
      @snippet.should exist
    end
    
  end
  
end
