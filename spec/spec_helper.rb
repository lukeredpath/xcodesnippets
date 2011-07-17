$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rspec'
require 'xcode_snippets'

RSpec.configure do |config|
  config.before(:each) do
    setup_testing_environment!
  end
end

TMP_PATH           = File.join(File.dirname(__FILE__), *%w[.. tmp specs])
FIXTURES_PATH      = File.join(File.dirname(__FILE__), *%w[.. features support fixtures])
XCODE_SNIPPET_PATH = File.join(TMP_PATH, "xcode-snippets")
SNIPPETS_PATH      = File.join(TMP_PATH, "snippets")

class FakeUUIDGenerator
  def self.use=(uuid)
    @uuid = uuid
  end
  
  def self.generate
    @uuid
  end
end

def setup_testing_environment!
  [SNIPPETS_PATH, XCODE_SNIPPET_PATH].each do |dir|
    FileUtils.rm_rf(dir) && FileUtils.mkdir_p(dir)
  end
  
  FakeUUIDGenerator.use = UUIDTools::UUID.timestamp_create
end
