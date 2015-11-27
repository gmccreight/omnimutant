require_relative "./spec_helper"

require "omnimutant/test_runner"

describe Omnimutant::TestRunner do

  def example_command_with_timeout(example, timeout)
    file = File.expand_path(File.dirname(__FILE__)) +
      "/examples/" + example
    command = "ruby " + file

    test_passing_regex =
      %r{[1-9][0-9]* (runs|tests), [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}
    runner = Omnimutant::TestRunner.new(
      timeout:timeout, test_command:command, test_passing_regex:test_passing_regex)
    runner.start_test()
    runner
  end

  describe "timeouts" do

    it "should report pass if the test passed and did not timeout" do
      runner = example_command_with_timeout("/ruby/example1_spec.rb", 3)
      assert_equal runner.exceeded_time?, false
      assert runner.passed?
    end

    it "should stop a program that runs too long, and report failure" do
      runner = example_command_with_timeout("/ruby/example2_spec.rb", 0.5)
      assert_equal runner.exceeded_time?, true
      assert ! runner.passed?
    end

  end

  describe "failure" do

    it "should not pass if the test does not pass" do
      runner = example_command_with_timeout("/ruby/example3_spec.rb", 3)
      assert ! runner.passed?
    end

  end

end
