module XcodeSnippets
  class Runner
    def self.run(command)
      return_value = "<NO RESULT>"
      
      thread = Thread.fork do
        # Clamp::Command.run expects ARGV-style arguments
        begin
          return_value = XcodeSnippets::Main.run("xcodesnippets", command.split(" "))
        rescue StandardError => e
          return_value = e
        end
      end
      
      # need to wait until the thread has finished otherwise we
      # may get non-deterministic results due to commands starting
      # while a previous one has not finished
      while thread.alive?
      end
      
      return_value
    end
  end
end
