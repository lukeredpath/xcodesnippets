$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rspec'
require 'ruby-debug'
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
  def self.seed(uuids)
    @uuids = uuids
  end
  
  def self.generate
    @uuids.pop
  end
end

class FileQuery
  def initialize(path)
    @path = path
  end
  
  def exist?
    File.exist?(@path)
  end
  
  def to_s
    "<file at #{@path}>"
  end
end

def file_at(path)
  FileQuery.new(path)
end

def directory(path)
  FileQuery.new(path)
end

def setup_testing_environment!
  [SNIPPETS_PATH, XCODE_SNIPPET_PATH].each do |dir|
    FileUtils.rm_rf(dir) && FileUtils.mkdir_p(dir)
  end
  
  # seed the generator with enough UUIDs for testing
  FakeUUIDGenerator.seed [
    UUIDTools::UUID.timestamp_create,
    UUIDTools::UUID.timestamp_create
  ]
end
