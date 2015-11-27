require_relative "./spec_helper"

require 'tempfile'
require "omnimutant"

describe Omnimutant::Runner do

  describe "run" do

    describe "the ruby example4" do

      before do
        src_dir = File.expand_path(File.dirname(__FILE__)) + "/examples/ruby"
        dest_dir = Dir.mktmpdir

        FileUtils.cp src_dir + '/example4.rb', dest_dir + '/example4.rb'
        FileUtils.cp src_dir + '/example4_spec.rb', dest_dir + '/example4_spec.rb'

        test_passing_regex =
          %r{[1-9][0-9]* (runs|tests), [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}

        @runner = Omnimutant::Runner.new(
          dirs_and_matchers:[[dest_dir, %r{example4\.rb}]],
          timeout:5,
          test_command:"ruby " + dest_dir + "/example4_spec.rb 2>&1",
          test_passing_regex:test_passing_regex,
          verbose:0
        )
        @runner.run()
      end

      it "should catch that the 'not five' condition is never tested" do
        @runner.get_report().select{|x| x[:original_line] =~ /not five/}
      end

    end

  end

end
