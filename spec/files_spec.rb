require_relative "./spec_helper"

require "omnimutant/string_mutator"

describe Omnimutant::SourceFilesFinder do

  def full_path_for(more)
    File.expand_path(File.dirname(__FILE__)) + more
  end

  def get_files(dirs, matchers)
  end

  it "should find the files" do
    dirs = [full_path_for("/examples/ruby")]
    matchers = [%r{example1}]

    f = Omnimutant::SourceFilesFinder.new(dirs:dirs, matchers:matchers)
    files = f.get_files()

    files.map{|x| x.gsub!(/.*\//, '')}
    assert_equal ["example1.rb", "example1_spec.rb"], files
  end

end
