require 'timeout'

module Omnimutant

  class Runner

    def initialize(dirs:, matchers:, timeout:, test_command:,
                   test_passing_regex:, verbose:0)
      @dirs = dirs
      @matchers = matchers
      @timeout = timeout
      @test_command = test_command
      @test_passing_regex = test_passing_regex
      @verbose = verbose

      @results = Omnimutant::Results.new()
    end

    def run
      @results.reset()
      source_files = get_the_source_files()
      iterator = Omnimutant::FileIterator.new(files:source_files)
      while ! iterator.is_beyond_end?
        vputs(1, "file: " + iterator.get_current_file)
        mutator = Omnimutant::FileMutator.
          new(filepath: iterator.get_current_file, verbose:@verbose)
        while ! mutator.is_done_mutating?
          mutator.do_next_mutation()
          vputs(1, "line number: " + mutator.get_current_line_number.to_s)

          test_runner = Omnimutant::TestRunner.new(
            timeout:@timeout,
            test_command:@test_command,
            test_passing_regex:@test_passing_regex,
            verbose:@verbose
          )
          test_runner.start_test()
          if test_runner.passed?
            vputs(3, File.read(iterator.get_current_file))
            @results.log_pass(
              filepath:iterator.get_current_file,
              line_number:mutator.get_current_line_number,
              original_line:mutator.get_original_line,
              mutated_line:mutator.get_mutated_line,
            )
            vputs(1, "unexpected pass")
            vputs(1, "orig: " + mutator.get_original_line.to_s)
            vputs(1, "mutated: " + mutator.get_mutated_line.to_s)
          end
        end
        iterator.move_next()
      end
    end

    def vputs(level, message)
      if @verbose >= level
        puts message
      end
    end

    def get_report
      @results.report()
    end

    private def get_the_source_files
      Omnimutant::SourceFilesFinder.
        new(dirs:@dirs, matchers:@matchers).get_files
    end

  end

end
