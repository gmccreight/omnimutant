require_relative "./spec_helper"

require 'tempfile'
require "omnimutant"

describe Omnimutant::Runner do

  describe "run" do

    before do
      src_dir = File.expand_path(File.dirname(__FILE__)) + "/examples/ruby"
      dest_dir = Dir.mktmpdir

      FileUtils.cp src_dir + '/example4.rb', dest_dir + '/example4.rb'
      FileUtils.cp src_dir + '/example4_spec.rb', dest_dir + '/example4_spec.rb'

      test_passing_regex =
        %r{[1-9][0-9]* tests, [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}

      @runner = Omnimutant::Runner.new(
        dirs:[dest_dir],
        matchers:[%r{example4\.rb}],
        timeout:5,
        test_command:"ruby " + dest_dir + "/example4_spec.rb 2>&1",
        test_passing_regex:test_passing_regex
      )
      @runner.run()
    end

    it "should catch that the 'not five' condition is never tested" do
      @runner.get_report().select{|x| x[:original_line] =~ /not five/}
    end

  end

end
