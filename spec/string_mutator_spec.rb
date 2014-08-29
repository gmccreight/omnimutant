require_relative "./spec_helper"

require "mutant/string_mutator"

describe Mutant::StringMutator do

  def mutate_string string
    mutator = Mutant::StringMutator.new(string)
    mutator.get_all_mutations()
  end

  it "should not replace ||= with &&=" do
    string = "value ||= 'default'"
    mutations = [
      "",
    ]
    assert_equal mutations, mutate_string(string)
  end

  it "should mutate both || to && and && to ||" do
    string = "hello || what && bye"
    mutations = [
      "",
      "hello || what || bye",
      "hello && what && bye"
    ]
    assert_equal mutations, mutate_string(string)
  end

  it "should have multiple mutations for the same replacement" do
    string = "hello && what && bye"
    mutations = [
      "",
      "hello || what && bye",
      "hello && what || bye"
    ]
    assert_equal mutations, mutate_string(string)
  end

  it "should mutate == to !=" do
    string = "if foo == bar"
    mutations = [
      "",
      "if foo != bar",
    ]
    assert_equal mutations, mutate_string(string)
  end

  it "should mutate != to ==" do
    string = "if foo != bar"
    mutations = [
      "",
      "if foo == bar",
    ]
    assert_equal mutations, mutate_string(string)
  end

  describe "method name" do

    it "should mutate a method with no parens" do
      string = "  def foo_bar"
      mutations = [
        "",
        "  def mutated_method_name_that_should_not_exist",
      ]
      assert_equal mutations, mutate_string(string)
    end

    it "should mutate a method with parens" do
      string = "def foo_bar(what)"
      mutations = [
        "",
        "def mutated_method_name_that_should_not_exist(what)",
      ]
      assert_equal mutations, mutate_string(string)
    end

  end

end
