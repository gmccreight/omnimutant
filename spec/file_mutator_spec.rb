require_relative "./spec_helper"

require "omnimutant/file_mutator"
require 'tempfile'

describe Omnimutant::FileMutator do

  def create_tmp_file
    @lines = []
    @lines << "class SomeClass"
    @lines << ""
    @lines << "  def calculate(base)"
    @lines << "    if base == 3"
    @lines << "      return 5"
    @lines << "    end"
    @lines << "    return 10"
    @lines << "  end"
    @lines << ""
    @lines << "end"

    @tmpfile = Tempfile.new('code')
    @tmpfile.write(@lines.join("\n"))
    @tmpfile.rewind()
    @tmpfile.close()
  end

  def read_tmp_file
    @tmpfile.open()
    @tmpfile.rewind()
    data = @tmpfile.read()
    @tmpfile.close()
    data
  end

  before do
    create_tmp_file
    @mutator = Omnimutant::FileMutator.new(@tmpfile.path)
  end

  # it "should modify == to != at some point" do
  #   50.times do
  #     @mutator.do_next_mutation
  #     lines = read_tmp_file.lines
  #     lines.select{|x| x =~ /if base/}.each{|x| puts x}
  #   end
  # end

  describe "completion" do

    it "should know that it is not yet done mutating" do
      10.times do
        @mutator.do_next_mutation
      end
      assert ! @mutator.is_done_mutating?
    end

    it "should know that it is done mutating" do
      100.times do
        @mutator.do_next_mutation
      end
      assert @mutator.is_done_mutating?
    end

  end

end
