module XcodeSnippets
  class Runner
    def self.run(command)
      Thread.fork do
        # Clamp::Command.run expects ARGV-style arguments
        XcodeSnippets::Main.run("xcodesnippets", command.split(" "))
      end
    end
  end
end
