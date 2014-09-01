require_relative "./spec_helper"

require "omnimutant/string_mutator"

describe Omnimutant::Files do

  def full_path_for(more)
    File.expand_path(File.dirname(__FILE__)) + more
  end

  def get_files(dirs, matchers)
    f = Omnimutant::Files.new(dirs:dirs, matchers:matchers)
    f.load()
    f.get_files()
  end

  it "should find the files" do
    dirs = [full_path_for("/examples/ruby")]
    matchers = [%r{example1}]

    files = get_files(dirs, matchers)
    files.map{|x| x.gsub!(/.*\//, '')}
    assert_equal ["example1.rb", "example1_spec.rb"], files
  end

end
