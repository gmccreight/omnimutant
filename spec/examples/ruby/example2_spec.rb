require_relative "./example2"

require "minitest/autorun"

describe Example2 do

  it "should work" do
    assert_equal "bar", Example2.new.foo()
  end

end
