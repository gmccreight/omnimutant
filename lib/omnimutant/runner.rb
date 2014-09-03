require 'timeout'

module Omnimutant

  class Runner

    def initialize(dirs:, matchers:, timeout:, test_command:, test_passing_regex:)
      @dirs = dirs
      @matchers = matchers
      @timeout = timeout
      @test_command = test_command
      @test_passing_regex = test_passing_regex

      @results = Omnimutant::Results.new()
    end

    def run
      @results.reset()
      source_files = get_the_source_files()
      iterator = Omnimutant::FileIterator.new(files:source_files)
      while ! iterator.is_beyond_end?
        mutator = Omnimutant::FileMutator.new(iterator.get_current_file)
        while ! mutator.is_done_mutating?
          mutator.do_next_mutation()
          test_runner = Omnimutant::TestRunner.new(
            timeout:@timeout,
            test_command:@test_command,
            test_passing_regex:@test_passing_regex
          )
          test_runner.start_test()
          if test_runner.passed?
            @results.log_pass(
              filepath:iterator.get_current_file,
              line_number:mutator.get_current_line_number,
              original_line:mutator.get_original_line,
              mutated_line:mutator.get_mutated_line,
            )
          end
        end
        iterator.move_next()
      end
    end

    def get_report
      @results.report()
    end

    private def get_the_source_files
      Omnimutant::SourceFilesFinder.new(dirs:@dirs, matchers:@matchers).get_files
    end

  end

end
