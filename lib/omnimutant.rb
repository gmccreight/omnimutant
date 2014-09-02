require_relative "omnimutant/source_files_finder"
require_relative "omnimutant/string_mutator"
require_relative "omnimutant/test_runner"
require_relative "omnimutant/file_iterator"
require_relative "omnimutant/file_mutator"

def intialize(dirs:, matchers:, timeout:, test_command:, test_passing_regex:)
  @dirs = dirs
  @matchers = matchers
  @timeout = timeout
  @test_command = test_command
  @test_passing_regex = test_passing_regex
end

def run
  results = Omnimutant::Results.new()

  source_files = get_the_source_files()
  iterator = Omnimutant::FileIterator.new(source_files)
  while ! iterator.is_at_end?
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
        results.log_pass(
          filepath:iterator.get_current_file,
          line_number:mutator.get_current_line_number,
          original_line:mutator.get_original_line,
          mutated_line:mutator.get_mutated_line,
        )
      end
    end
  end

  results.report()
end

private def get_the_source_files
  Omnimutant::SourceFilesFinder.new(dirs:@dirs, matchers:@matchers)
end
