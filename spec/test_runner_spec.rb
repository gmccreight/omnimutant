require_relative "./spec_helper"

require "omnimutant/test_runner"

describe Omnimutant::TestRunner do

  def example_command_with_timeout(example, timeout)
    file = File.expand_path(File.dirname(__FILE__)) +
      "/examples/" + example
    command = "ruby " + file
    runner = Omnimutant::TestRunner.new(timeout:timeout, test_command:command)
    runner.start_test()
    runner
  end

  it "should get the results from running the command" do
    runner = example_command_with_timeout("/ruby/example1_spec.rb", 3)
    assert_equal runner.exceeded_time?, false
    assert_equal runner.get_result.lines.last.chomp,
      "1 tests, 1 assertions, 0 failures, 0 errors, 0 skips"
  end

  it "should stop a program that runs too long" do
    runner = example_command_with_timeout("/ruby/example2_spec.rb", 1)
    assert_equal runner.exceeded_time?, true
    assert_equal runner.get_result, ""
  end

end
