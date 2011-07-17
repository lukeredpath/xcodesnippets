module XcodeSnippets
  class Runner
    def self.run(command)
      Thread.fork do
        XcodeSnippets::Main.run(command.gsub(/xcodesnippets/, "").strip)
      end
    end
  end
end
