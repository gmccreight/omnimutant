require_relative "./example3"

require "minitest/autorun"

describe Example3 do

  it "should work" do # this fails on purpose
    assert_equal "bar", Example3.new.foo()
  end

end
