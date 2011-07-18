module XcodeSnippets
  module Version
    MAJOR = 0
    MINOR = 2
    TINY  = 0
    
    def self.to_s
      "#{MAJOR}.#{MINOR}.#{TINY}"
    end
  end
end
