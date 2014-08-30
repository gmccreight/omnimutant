require_relative "./example1"

require "minitest/autorun"

describe Example1 do

  it "should work" do
    assert_equal "bar", Example1.new.foo()
  end

end
