module XcodeSnippets
  class Runner
    def self.run(command)
      thread = Thread.fork do
        # Clamp::Command.run expects ARGV-style arguments
        XcodeSnippets::Main.run("xcodesnippets", command.split(" "))
      end
      
      # need to wait until the thread has finished otherwise we
      # may get non-deterministic results due to commands starting
      # while a previous one has not finished
      while thread.alive?
      end
    end
  end
end
