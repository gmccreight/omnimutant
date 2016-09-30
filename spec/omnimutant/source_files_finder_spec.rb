require_relative "../spec_helper"

require "omnimutant/source_files_finder"

describe Omnimutant::SourceFilesFinder do

  it "should find all the files (including nested)" do
    dirs_and_matchers = [[examples_path + "/ruby", %r{example1}]]

    f = Omnimutant::SourceFilesFinder.new(dirs_and_matchers: dirs_and_matchers)
    files = f.get_files()

    files.map{|x| x.gsub!(/.*\//, '')}
    assert_equal ["example1.rb", "example1_spec.rb", "nested_example1.rb"], files
  end

  describe "excluding specific directories and files" do

    it "should be able to exclude nested directory and file" do
      dirs_and_matchers = [[examples_path + "/ruby", %r{example1}]]
      exclude_dirs_and_matchers = [[examples_path + "/ruby/nested", %r{.}]]

      f = Omnimutant::SourceFilesFinder.new(
        dirs_and_matchers: dirs_and_matchers,
        exclude_dirs_and_matchers: exclude_dirs_and_matchers,
      )
      files = f.get_files()

      files.map{|x| x.gsub!(/.*\//, '')}
      assert_equal ["example1.rb", "example1_spec.rb"], files
    end

    it "should not exclude the file in the nested directory if file regex not matching" do
      dirs_and_matchers = [[examples_path + "/ruby", %r{example1}]]
      exclude_dirs_and_matchers = [[examples_path + "/ruby/nested", %r{NOPE}]]

      f = Omnimutant::SourceFilesFinder.new(
        dirs_and_matchers: dirs_and_matchers,
        exclude_dirs_and_matchers: exclude_dirs_and_matchers,
      )
      files = f.get_files()

      files.map{|x| x.gsub!(/.*\//, '')}
      assert_equal ["example1.rb", "example1_spec.rb", "nested_example1.rb"], files
    end

  end

end
