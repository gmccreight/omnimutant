# Run this file with:
# ruby -Ilib ./example_mutant_for.rb

require "omnimutant"

base_dir = "/Users/gmccreight/code/mdpg"
source_dir = base_dir + "/lib"

test_passing_regex =
  %r{[1-9][0-9]* (runs|tests), [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}

runner = Omnimutant::Runner.new(
  dirs_and_matchers:[[source_dir, %r{search\.rb$}]],
  timeout:5,
  test_command:"cd #{base_dir}; rake 2>&1",
  test_passing_regex:test_passing_regex,
  verbose:1
)

runner.run()

puts runner.get_report()
