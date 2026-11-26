require "test_helper"

class CrystalTest < RepresenterTest
  extend UpstreamTests

  track "crystal"

  DEVIATIONS = {
    "example-syntax-error" => {
      unrepresentable: true,
      why: "The solution has a syntax error, so it gets no representation. The old representer printed the code unchanged."
    }
  }.freeze

  upstream_tests ".cr", deviations: DEVIATIONS

  # The old test with two solution files, which upstream_tests can't take. It
  # has its input files, the old representation split into one equivalent file
  # for each input file, and the old mapping.
  Dir[File.join(__dir__, "..", "fixtures", "crystal-multi-file", "*")].sort.each do |dir|
    define_method("test_upstream_#{File.basename(dir)}") do
      mapping = JSON.parse(File.read(File.join(dir, "expected_mapping.json")))
      inputs = Dir[File.join(dir, "*.cr")].to_h { |path| [File.basename(path), File.read(path)] }
      equivalents = Dir[File.join(dir, "equivalent", "*.cr")].to_h { |path| [File.basename(path), File.read(path)] }
      assert_equal inputs.keys.sort, equivalents.keys.sort

      actual = Representer::RepresentSolution.("crystal", inputs, {})
      assert_equal Representer::RepresentSolution.("crystal", equivalents, {}).representation, actual.representation
      assert_equal mapping.values.sort, actual.mapping.values.sort
    end
  end

  def wrap(body) = "class C\n#{body}\nend\n"

  def test_comments_are_dropped
    assert_same_representation "x = 1", "# a\nx = 1 # b\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same_representation "x = (1 + 2)", "x = 1 + 2"
    assert_same_representation "puts(1)", "puts 1"
    refute_same_representation "x = (1 + 2) * 3", "x = 1 + 2 * 3"
  end

  def test_a_call_without_arguments_has_one_spelling
    assert_same_representation "def f(a)\n  g()\nend", "def f(a)\n  g\nend"
    assert_same_representation "def f()\n  1\nend", "def f\n  1\nend"
  end

  def test_modifiers_are_the_same_as_block_forms
    assert_same_representation "puts 1 if a", "if a\n  puts 1\nend"
    assert_same_representation "puts 1 unless a", "unless a\n  puts 1\nend"
    refute_same_representation "puts 1 if a", "puts 1 unless a"
  end

  def test_blocks_written_with_do_or_braces_are_the_same
    assert_same_representation "a.map { |x| x + 1 }", "a.map do |x|\n  x + 1\nend"
  end

  def test_strings
    assert_same_representation 'x = "a\\u0041"', 'x = "aA"'
    assert_same_representation 'x = "a b"', "x = %q(a b)"
    assert_same_representation 'x = ["a", "b"]', "x = %w(a b)"
    refute_same_representation 'x = "a"', 'x = "b"'
    refute_same_representation 'x = "a\\qb"', 'x = "aqb"'
    refute_same_representation "x = \"a\#{b}\"", 'x = "a"'
  end

  def test_symbols_and_numbers
    assert_same_representation "x = :\"abc\"", "x = :abc"
    assert_same_representation "x = 1_000", "x = 1000"
    refute_same_representation "x = 1", "x = 2"
    refute_same_representation "x = 1.5", "x = 2.5"
  end

  def test_multiple_assignment_renames_every_variable
    assert_same_representation "def f\n  a, b = 1, 2\n  a + b\nend", "def f\n  x, y = 1, 2\n  x + y\nend"
    refute_same_representation "def f\n  a, b = 1, 2\n  a + b\nend", "def f\n  a, b = 1, 2\n  a - b\nend"
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation "def f(a, b = 1)\n  c = a + b\n  c\nend", "def f(x, y = 1)\n  z = x + y\n  z\nend"
    assert_same_representation "def f(a)\n  a.each { |i| puts i }\nend", "def f(x)\n  x.each { |j| puts j }\nend"
    refute_same_representation "def f(a, b)\n  a\nend", "def f(a, b)\n  b\nend"
  end

  def test_instance_variables_are_renamed
    code = "class C\n  def initialize(@%s : Int32)\n  end\n  def v\n    @%s\n  end\nend"
    assert_same_representation format(code, "a", "a"), format(code, "b", "b")
  end

  def test_methods_and_classes_are_renamed_where_they_are_called
    code = "class %s\n  def %s\n    1\n  end\nend\n%s.new.%s"
    assert_same_representation format(code, "A", "x", "A", "x"), format(code, "B", "y", "B", "y")
  end

  def test_getters_and_properties_define_methods
    code = "class C\n  property %s : Int32\n  getter %s\nend\nc = C.new\nc.%s"
    assert_same_representation format(code, "a", "b", "a"), format(code, "x", "y", "x")
  end

  def test_paths_are_renamed_by_their_parts
    code = "module %s\n  class %s\n  end\nend\n%s::%s.new"
    assert_same_representation format(code, "A", "B", "A", "B"), format(code, "X", "Y", "X", "Y")
    refute_same_representation "Math::PI", "Math::E"
  end

  def test_the_order_of_methods_does_not_matter
    assert_same_representation wrap("def a\n  1\nend\ndef b(x)\n  x + 1\nend"), wrap("def b(x)\n  x + 1\nend\ndef a\n  1\nend")
    refute_same_representation wrap("def a\n  1\nend\ndef b\n  2\nend"), wrap("def a\n  1\nend\ndef b\n  3\nend")
  end

  def test_a_method_named_like_a_library_method_keeps_its_name
    code = "class C\n  def %s\n    1\n  end\nend"
    refute_same_representation format(code, "sum"), format(code, "max")
    assert_same_representation format(code, "total"), format(code, "amount")
  end

  def test_methods_crystal_calls_keep_their_names
    code = "class C\n  def %s\n    1\n  end\nend"
    refute_same_representation format(code, "to_s"), format(code, "show")
  end

  def test_names_the_tests_use_are_kept
    refute_same_representation "def f\n  1\nend", "def g\n  1\nend",
      exercise_files: { "spec/t_spec.cr" => "it \"x\" do\n  f.should eq 1\nend\n" }
  end

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "def f(\n"
  end

  def test_getter_and_property_symbols_are_renamed
    assert_same_representation "class A\n  getter :alpha\n  def initialize(@alpha : Int32); end\n  def f\n    alpha\n  end\nend\n",
      "class A\n  getter :beta\n  def initialize(@beta : Int32); end\n  def f\n    beta\n  end\nend\n"
    assert_same_representation "class A\n  property :alpha\nend\n", "class A\n  property alpha\nend\n"
  end

  def test_top_level_methods_are_sorted
    assert_same_representation "def a\n  1\nend\n\ndef b(x)\n  x + 1\nend\n", "def b(x)\n  x + 1\nend\n\ndef a\n  1\nend\n"
  end

  def test_requires_are_dropped
    assert_same_representation "require \"big\"\nclass C\nend", "class C\nend"
  end

  def test_numbers_are_their_values
    assert_same_representation "X = 4400000000_i64", "X = 4400000000"
    assert_same_representation "X = 1_000 + 0x1F + 1_i32", "X = 1000 + 31 + 1"
    assert_same_representation "X = 1.50 + 2.0_f64", "X = 1.5 + 2.0"
    refute_same_representation "X = 1_i64", "X = 1"
    refute_same_representation "X = 1.0_f32", "X = 1.0"
    refute_same_representation "X = 1.0", "X = 1"
  end

  def test_operator_methods_are_operators
    assert_same_representation "X = (1..n).sum.**(2)", "X = (1..n).sum ** 2"
    refute_same_representation "X = (1..n).sum ** 2", "X = (1..n).sum * 2"
  end
end
