Feature: Installing snippet bundles
  In order to use groups of related snippets more easily
  As an Xcode user
  I want be able to install bundles of snippets
  
    Background:
      Given Xcode snippets are stored in "tmp/xcode-snippets"
        And installed snippets are stored in "tmp/snippets"

    Scenario: Installing a bundle with a single snippet
      Given I have the snippet bundle "tmp/SampleSnippets.snippetbundle"
        And the bundle contains the snippet "example-snippet.codesnippet"
      When I run xcodesnippets with "install-bundle tmp/SampleSnippets.snippetbundle"
      Then the snippet file should be installed to "tmp/snippets/SampleSnippets.snippetbundle/example-snippet.codesnippet"
      And the installed snippet files should be symlinked inside "tmp/xcode-snippets"
