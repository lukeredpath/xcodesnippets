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
    And the installed snippet files should be symlinked inside "tmp/xcode-snippets"
  
  Scenario: Installing multiple snippets
    Given I have the snippet file "tmp/example-snippet-one.codesnippet"
    And I have the snippet file "tmp/example-snippet-two.codesnippet"
    When I run xcodesnippets with "install tmp/example-snippet-one.codesnippet tmp/example-snippet-two.codesnippet"
    Then the snippet files should be installed to "tmp/snippets/Default.snippetbundle"
    And the installed snippet files should be symlinked inside "tmp/xcode-snippets"
  
  Scenario: Uninstalling a snippet
    Given I have installed the snippet file "tmp/example-snippet.codesnippet"
    When I run xcodesnippets with "uninstall example-snippet"
    Then the snippet file "tmp/snippets/Default.snippetbundle/example-snippet.codesnippet" should not exist
    And it's symlink should be removed
    