require_relative "../spec_helper"

require "omnimutant/source_files_finder"

describe Omnimutant::SourceFilesFinder do

  it "should find the files" do
    dirs_and_matchers = [[examples_path + "/ruby", %r{example1}]]

    f = Omnimutant::SourceFilesFinder.new(dirs_and_matchers: dirs_and_matchers)
    files = f.get_files()

    files.map{|x| x.gsub!(/.*\//, '')}
    assert_equal ["example1.rb", "example1_spec.rb"], files
  end

end
