require "test_helper"

class WrenTest < RepresenterTest
  extend UpstreamTests

  track "wren"

  RENAMED_WHY = "A method that the solution defines is renamed, even if its name is `new`, or one of Wren's core " \
                "library or language methods. The old representer kept `new`.".freeze

  upstream_tests ".wren", renamed: { %w[new] => %w[queens] }, renamed_why: RENAMED_WHY

  # The old test with three solution files, which upstream_tests can't take.
  # It has its input files, an equivalent file for each input file, and the
  # old mapping.
  Dir[File.join(__dir__, "..", "fixtures", "wren-multi-file", "*")].sort.each do |dir|
    define_method("test_upstream_#{File.basename(dir)}") do
      mapping = JSON.parse(File.read(File.join(dir, "expected_mapping.json")))
      inputs = Dir[File.join(dir, "*.wren")].to_h { |path| [File.basename(path), File.read(path)] }
      equivalents = Dir[File.join(dir, "equivalent", "*.wren")].to_h { |path| [File.basename(path), File.read(path)] }
      assert_equal inputs.keys.sort, equivalents.keys.sort

      actual = Representer::RepresentSolution.("wren", inputs, {})
      assert_equal Representer::RepresentSolution.("wren", equivalents, {}).representation, actual.representation
      assert_equal mapping.values.sort, actual.mapping.values.sort
    end
  end

  def wrap(body) = "class C {\n#{body}\n}"

  def test_comments_are_dropped
    assert_same_representation "var a = 1", "// one\n/* two /* nested */ */\nvar a = 1 // three"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same_representation "var a = (1 + 2)", "var a = 1 + 2"
    refute_same_representation "var a = (1 + 2) * 3", "var a = 1 + 2 * 3"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "var a = 1\nSystem.print(a)", "var b = 1\nSystem.print(b)"
    assert_same_representation wrap("foo(x) { x }"), wrap("bar(y) { y }")
    assert_same_representation wrap("construct make(a) { _x = a }"), wrap("construct build(b) { _y = b }")
    assert_same_representation "class A {}", "class B {}"
    assert_same_representation "for (i in 1..3) { System.print(i) }", "for (j in 1..3) { System.print(j) }"
    assert_same_representation "var f = Fn.new {|x| x }", "var f = Fn.new {|y| y }"
  end

  def test_methods_are_renamed_where_they_are_called
    assert_same_representation "class A { foo { 1 } }\nvar a = A.new().foo", "class A { bar { 1 } }\nvar a = A.new().bar"
    refute_same_representation "var a = b.foo", "var a = b.bar"
  end

  def test_names_from_outside_are_kept_if_the_solution_only_calls_them
    refute_same_representation "var a = b.map {|x| x }", "var a = b.where {|x| x }"
    refute_same_representation "System.print(1)", "System.write(1)"
    assert_same_representation wrap("contains(x) { x.contains(1) }"), wrap("indexOf(x) { x.indexOf(1) }")
    assert_same_representation wrap("toString { \"a\" }"), wrap("other { \"a\" }")
  end

  def test_names_from_the_tests_are_kept
    tests = { "two_fer.spec.wren" => "import \"./two_fer\" for TwoFer\nSystem.print(TwoFer.twoFer())" }
    refute_same_representation "class TwoFer { static twoFer() { 1 } }", "class TwoFer { static other() { 1 } }",
      exercise_files: tests
  end

  def test_fields_are_renamed
    assert_same_representation wrap("foo { _a }"), wrap("foo { _b }")
    assert_same_representation wrap("static foo { __a }"), wrap("static foo { __b }")
    refute_same_representation wrap("foo { _a }"), wrap("foo { __a }")
  end

  def test_strings
    assert_same_representation 'var a = "a\\nb"', 'var a = "a\\nb"'
    assert_same_representation 'var a = """a"""', 'var a = "a"'
    refute_same_representation 'var a = "a"', 'var a = "b"'
    refute_same_representation 'var a = "%(b)"', 'var a = "%(c)"'
    assert_same_representation 'var a = "\\u0041"', 'var a = "A"'
  end

  def test_numbers_have_one_spelling
    assert_same_representation "var a = 1.0", "var a = 1"
    assert_same_representation "var a = 1.50", "var a = 1.5"
    refute_same_representation "var a = 1.5", "var a = 1.25"
  end

  def test_a_block_with_one_statement_is_the_statement
    assert_same_representation "if (a) { b() }", "if (a) b()"
    assert_same_representation "while (a) { b() }", "while (a) b()"
    assert_same_representation "if (a) { b() } else { c() }", "if (a) b() else c()"
    refute_same_representation "if (a) { b() }", "if (a) { b()\nc() }"
  end

  def test_the_order_of_a_maps_entries_is_ignored
    assert_same_representation 'var m = {"b": 1, "a": 2}', 'var m = {"a": 2, "b": 1}'
    refute_same_representation 'var m = {"a": 1}', 'var m = {"a": 2}'
  end

  def test_the_order_of_imports_is_ignored
    assert_same_representation "import \"a\" for A\nimport \"b\" for B\nvar x = 1",
      "import \"b\" for B\nimport \"a\" for A\nvar x = 1"
  end

  def test_a_getter_and_a_method_stay_apart
    refute_same_representation wrap("foo { 1 }"), wrap("foo() { 1 }")
    refute_same_representation "var a = b.foo", "var a = b.foo()"
  end

  def test_a_syntax_error_is_unrepresentable
    assert_unrepresentable "class {"
  end

  def test_imports_are_dropped
    assert_same_representation "import \"random\" for Random\nvar x = 1", "var x = 1"
  end

  def test_numbers_are_their_values
    assert_same_representation "var x = 1.0 + 0x1F + 1.50 + 1e3", "var x = 1 + 31 + 1.5 + 1000"
    refute_same_representation "var x = 1.5", "var x = 1.6"
  end
end
