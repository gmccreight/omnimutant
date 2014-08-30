require 'timeout'

module Omnimutant

  class TestRunner

    def initialize(timeout:, test_command:)
      @timeout = timeout
      @test_command = test_command
      @exceeded_timeout = false
    end

    def start_test
      @result = execute_with_timeout!(@test_command, @timeout)
    end

    def get_result
      @result
    end

    def exceeded_time?
      @exceeded_timeout
    end

    private def execute_with_timeout!(command, timeout)
      begin
        pipe = IO.popen(command, 'r')
      rescue Exception => e
        raise "Execution of command #{command} unsuccessful"
      end

      output = ""
      begin
        status = Timeout::timeout(timeout) {
          Process.waitpid2(pipe.pid)
          output = pipe.gets(nil)
        }
      rescue Timeout::Error
        Process.kill('KILL', pipe.pid)
        @exceeded_timeout = true
      end
      pipe.close
      output
    end

  end

end
