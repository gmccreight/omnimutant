require_relative "./spec_helper"

require 'tempfile'
require "omnimutant"

describe Omnimutant::Runner do

  describe "run" do

    it "should run to completion" do

      src_dir = File.expand_path(File.dirname(__FILE__)) + "/examples/ruby"
      dest_dir = Dir.mktmpdir

      FileUtils.cp src_dir + '/example1.rb', dest_dir + '/example1.rb'
      FileUtils.cp src_dir + '/example1_spec.rb', dest_dir + '/example1_spec.rb'

      test_passing_regex =
        %r{[1-9][0-9]* tests, [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}

      om = Omnimutant::Runner.new(
        dirs:[dest_dir],
        matchers:[%r{example1\.rb}],
        timeout:5,
        test_command:"ruby " + dest_dir + "/example1_spec.rb",
        test_passing_regex:test_passing_regex
      )

      om.run()
      puts om.get_report()
    end

  end

end
