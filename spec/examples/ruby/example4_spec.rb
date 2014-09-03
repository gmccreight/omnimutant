require_relative "./example4"

require "minitest/autorun"

describe Example4 do

  it "should work" do
    assert_equal "five", Example4.new.print_five(5)
  end

end
