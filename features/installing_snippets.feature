Feature: Installing snippets
  In order to use other people's snippets
  As an Xcode user
  I want be able to install snippets to Xcode's snippet folder
  
  Background:
    Given Xcode snippets are stored in "tmp/xcode-snippets"
    And installed snippets are stored in "tmp/snippets"
  
  Scenario: Installing a single snippet
    Given I have the snippet file "tmp/example-snippet.snippet"
    When I run "xcodesnippets install tmp/example-snippet.snippet"
    Then the snippet file should be installed to "tmp/snippets/example-snippet.snippet"
    And the installed snippet file should be symlinked inside "tmp/xcode-snippets"
  