require File.join(File.dirname(__FILE__), *%w[.. .. lib xcode_snippets])
require File.join(File.dirname(__FILE__), *%w[runner])

require 'ruby-debug'

def configuration
  @configuration ||= OpenStruct.new
end
