module BigTuna
  class Runner
    def self.execute(dir, command)
      end_command = "cd #{dir} && #{command}"
      BigTuna.logger.debug("Executing: #{end_command}")
      with_clean_env do
        output = Output.new(dir, command)
        buffer = []
        status = Open4.popen4(end_command) do |_, _, stdout, stderr|
          while !stdout.eof? or !stderr.eof?
            output.append_stdout(stdout.read_nonblock(2 ** 10)) rescue Errno::EAGAIN
            output.append_stderr(stderr.read_nonblock(2 ** 10)) rescue Errno::EAGAIN
          end
        end
        output.finish(status.exitstatus)
        raise Error.new(output) if output.exit_code != 0
        output
      end
    end

    def self.with_clean_env
      Bundler.with_clean_env do
        yield
      end
    end

    class Error < Exception
      attr_reader :output

      def initialize(output)
        @output = output
      end

      def message
        "Error (#{@output.exit_code}) executing '#{@output.command}' in '#{@output.dir}'"
      end
    end
  end
end
