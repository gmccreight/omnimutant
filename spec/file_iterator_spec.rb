require_relative "./spec_helper"

require "omnimutant/file_iterator"

describe Omnimutant::FileIterator do

  before do
    @iterator = Omnimutant::FileIterator.new(files:["test1.rb", "test2.rb"])
  end

  it "should understand when it is at the end" do
    assert !@iterator.is_at_end?
    @iterator.move_next()
    assert @iterator.is_at_end?
  end

  it "should know what file it is on" do
    assert_equal "test1.rb", @iterator.get_current_file
    @iterator.move_next()
    assert_equal "test2.rb", @iterator.get_current_file
  end

end
