Feature: Migrating existing bundles
  In order to start using xcodesnippets with my existing snippets straight away
  As an Xcode user
  I want to be able to bring all of my existing snippets under xcodesnippets control

  Background:
    Given Xcode snippets are stored in "tmp/xcode-snippets"
    And installed snippets are stored in "tmp/snippets"
    
  Scenario: Migrating existing snippets to default bundle
    Given I have the existing snippet "8CBED4F4-DD88-4C04-A456-24C786002C0F.codesnippet"
    When I run xcodesnippets with "migrate --skip-confirm"
    Then the snippet file should be installed to "tmp/snippets/Default.snippetbundle/appledoc class.codesnippet"
    And the installed snippet files should be symlinked inside "tmp/xcode-snippets"
