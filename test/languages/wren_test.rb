require "test_helper"

class WrenTest < RepresenterTest
  extend UpstreamTests

  track "wren"

  RENAMED_WHY = "A method that the solution defines is renamed, even if its name is `new`, or one of Wren's core " \
                "library or language methods. The old representer kept `new`.".freeze

  upstream_tests ".wren", renamed: { ["new"] => ["queens"] }, renamed_why: RENAMED_WHY

  # The old test with three solution files, which upstream_tests can't take.
  # It has its input files, an equivalent file for each input file, and the
  # old mapping.
  Dir[File.join(__dir__, "..", "fixtures", "wren-multi-file", "*")].sort.each do |dir|
    define_method("test_upstream_#{File.basename(dir)}") do
      mapping = JSON.parse(File.read(File.join(dir, "expected_mapping.json")))
      inputs = Dir[File.join(dir, "*.wren")].to_h { |path| [File.basename(path), File.read(path)] }
      equivalents = Dir[File.join(dir, "equivalent", "*.wren")].to_h { |path| [File.basename(path), File.read(path)] }
      assert_equal inputs.keys.sort, equivalents.keys.sort

      actual = Representer::RepresentSolution.("wren", inputs)
      assert_equal Representer::RepresentSolution.("wren", equivalents).representation, actual.representation
      assert_equal mapping.values.sort, actual.mapping.values.sort
    end
  end

  def test_comments_are_dropped
    assert_same_representation "var a = 1", "// one\n/* two /* nested */ */\nvar a = 1 // three"
  end

  def test_imports_are_dropped
    assert_same_representation "import \"random\" for Random\nvar x = 1", "var x = 1"
    assert_same_representation "import \"a\" for A, B\nimport \"b\"\nvar x = 1", "var x = 1"
  end

  def test_names_from_outside_are_kept_if_the_solution_only_calls_them
    refute_same_representation "var a = b.map {|x| x }", "var a = b.where {|x| x }"
    refute_same_representation "System.print(1)", "System.write(1)"
  end

  def test_a_syntax_error_is_unrepresentable
    assert_unrepresentable "class {"
  end
end
