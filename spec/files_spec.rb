require_relative "./spec_helper"

require "omnimutant/string_mutator"

describe Omnimutant::SourceFilesFinder do

  def full_path_for(more)
    File.expand_path(File.dirname(__FILE__)) + more
  end

  it "should find the files" do
    dirs_and_matchers = [[full_path_for("/examples/ruby"), %r{example1}]]

    f = Omnimutant::SourceFilesFinder.new(dirs_and_matchers:dirs_and_matchers)
    files = f.get_files()

    files.map{|x| x.gsub!(/.*\//, '')}
    assert_equal ["example1.rb", "example1_spec.rb"], files
  end

end
