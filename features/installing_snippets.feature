Feature: Installing snippets
  In order to use other people's snippets
  As an Xcode user
  I want be able to install snippets to Xcode's snippet folder
  
  Background:
    Given Xcode snippets are stored in "tmp/xcode-snippets"
    And installed snippets are stored in "tmp/snippets"
  
  Scenario: Installing a single snippet
    Given I have the snippet file "tmp/example-snippet.codesnippet"
    When I run xcodesnippets with "install tmp/example-snippet.codesnippet"
    Then the snippet file should be installed to "tmp/snippets/Default.snippetbundle/example-snippet.codesnippet"
    And the installed snippet file should be symlinked inside "tmp/xcode-snippets"
  