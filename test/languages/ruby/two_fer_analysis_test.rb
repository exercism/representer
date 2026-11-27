require_relative "stage_helper"

class RubyTwoFerAnalysisTest < Minitest::Test
  include RubyAnalysis

  def test_the_exemplar_gets_the_interpolation_comment
    assert_equal [["ruby.two-fer.string_interpolation", { name_variable: "name" }]],
      analyse("def self.two_fer(name = \"you\")\n  \"One for \#{name}, one for me.\"\nend")
  end

  def test_every_way_of_defining_the_method_on_the_class_counts
    interpolation = [["ruby.two-fer.string_interpolation", { name_variable: "name" }]]
    method = "def two_fer(name = \"you\")\n    \"One for \#{name}, one for me.\"\n  end"
    assert_equal interpolation, comments("two-fer", "class TwoFer\n  def TwoFer.#{method[4..]}\nend\n")
    assert_equal interpolation, comments("two-fer", "module TwoFer\n  module_function\n\n  #{method}\nend\n")
    assert_equal interpolation, comments("two-fer", "class TwoFer\n  class << self\n    #{method.gsub("\n", "\n  ")}\n  end\nend\n")
  end

  def test_a_missing_module_or_method
    assert_equal ["ruby.general.no_target_module"], comments("two-fer", "class Other\nend\n")
    assert_equal ["ruby.general.no_target_method"], comments("two-fer", "class TwoFer\n  def two_fer(name = \"you\") = name\nend\n")
  end

  def test_the_parameter
    assert_equal [["ruby.two-fer.splat_args", { name_variable: "args" }]], analyse("def self.two_fer(*args)\n  args\nend")
    assert_equal ["ruby.two-fer.missing_default_param"], analyse("def self.two_fer(name)\n  name\nend")
    assert_equal ["ruby.two-fer.missing_default_param"], analyse("def self.two_fer(name = \"you\", other = 1)\n  name\nend")
    assert_equal ["ruby.two-fer.missing_default_param"], analyse("def self.two_fer(*args, name)\n  name\nend")
  end

  def test_other_ways_of_building_the_string
    assert_equal [["ruby.two-fer.string_concatenation", { name_variable: "name" }]],
      analyse("def self.two_fer(name = \"you\")\n  \"One for \" + name + \", one for me.\"\nend")
    assert_equal [["ruby.two-fer.kernel_format", { name_variable: "name" }]],
      analyse("def self.two_fer(name = \"you\")\n  format(\"One for %s, one for me.\", name)\nend")
    assert_equal [["ruby.two-fer.string_format", { name_variable: "name" }]],
      analyse("def self.two_fer(name = \"you\")\n  \"One for %s, one for me.\" % name\nend")
  end

  def test_a_string_inside_other_code_gets_no_comment
    assert_empty analyse("def self.two_fer(name = \"you\")\n  puts(\"One for \#{name}, one for me.\")\nend")
  end

  def test_an_explicit_return
    assert_equal ["ruby.general.explicit_return"],
      analyse("def self.two_fer(name = \"you\")\n  return \"One for \#{name}, one for me.\"\nend")
  end

  def test_indentation_replaces_the_comment
    assert_equal ["ruby.general.incorrect_indentation"],
      comments("two-fer", "class TwoFer\n   def self.two_fer(name = \"you\")\n     \"One for \#{name}, one for me.\"\n   end\nend\n")
    assert_equal ["ruby.general.incorrect_indentation"],
      comments("two-fer", "class TwoFer\n\tdef self.two_fer(name = \"you\")\n\t\t\"One for \#{name}, one for me.\"\n\tend\nend\n")
  end

  def test_a_conditional_on_the_parameter
    ["if name", "if name.nil?", "unless name.empty?", "if name == nil", "if nil == name", "if !name"].each do |condition|
      branches = "\"One for \#{name}, one for me.\"\n  else\n    \"One for you, one for me.\""
      source = "def self.two_fer(name = nil)\n  #{condition}\n    #{branches}\n  end\nend"
      assert_equal ["ruby.two-fer.incorrect_default_param"], analyse(source), condition
    end
  end

  def test_an_elsif_counts_as_part_of_its_conditional
    source = "def self.two_fer(name = \"\")\n  if name == \"Alice\"\n    1\n  elsif name == \"Bob\"\n    2\n  end\nend"
    assert_equal ["ruby.two-fer.incorrect_default_param"], analyse(source)
  end

  def test_other_conditionals_are_left_to_a_mentor
    assert_empty analyse("def self.two_fer(name = nil)\n  x = 1 if a\n  y = 2 if b\n  name\nend")
    assert_empty analyse("def self.two_fer(name = nil)\n  name ||= \"you\" if a\n  name\nend")
  end

  def test_reassigning_the_parameter
    assert_equal ["ruby.two-fer.reassigning_param"],
      analyse("def self.two_fer(name = nil)\n  name ||= \"you\"\n  \"One for \#{name}, one for me.\"\nend")
    assert_empty analyse("def self.two_fer(name = nil)\n  name ||= \"you\"\n  other ||= 1\n  name\nend")
  end

  private
  # The comments for a method in a TwoFer class.
  def analyse(method) = comments("two-fer", "class TwoFer\n#{method.gsub(/^/, '  ')}\nend\n")
end
