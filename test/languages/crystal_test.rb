require "test_helper"

class CrystalTest < InspectorTest
  extend UpstreamTests

  track "crystal"

  DEVIATIONS = {
    "example-syntax-error" => {
      parse_error: true,
      why: "The solution has a syntax error, so it gets Basic's representation. The old representer printed the code unchanged."
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

      actual = Inspector::RepresentSolution.("crystal", inputs)
      assert_equal Inspector::RepresentSolution.("crystal", equivalents).representation, actual.representation
      assert_equal mapping.values.sort, actual.mapping.values.sort
    end
  end

  def test_requires_are_dropped
    assert_same_representation "require \"big\"\nclass C\nend", "class C\nend"
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "def f(\n"
  end

  def test_names_are_renamed_wherever_they_appear
    code = "class %s\n  def %s\n    1\n  end\nend\n%s.new.%s"
    assert_same_representation format(code, "A", "x", "A", "x"), format(code, "B", "y", "B", "y")
    code = "module %s\n  class %s\n  end\nend\n%s::%s.new"
    assert_same_representation format(code, "A", "B", "A", "B"), format(code, "X", "Y", "X", "Y")
    refute_same_representation "x = Math::PI", "x = Math::E"
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation "def f(a, b = 1)\n  c = a + b\n  c\nend", "def f(x, y = 1)\n  z = x + y\n  z\nend"
    assert_same_representation "def f\n  a, b = 1, 2\n  a + b\nend", "def f\n  x, y = 1, 2\n  x + y\nend"
    refute_same_representation "def f(a, b)\n  a\nend", "def f(a, b)\n  b\nend"
    refute_same_representation "def f\n  a, b = 1, 2\n  a + b\nend", "def f\n  a, b = 1, 2\n  a - b\nend"
  end

  def test_accessors_and_their_instance_variables_are_renamed_together
    code = "class C\n  property %s : Int32\n  getter %s : String\nend\nc = C.new\nc.%s"
    assert_same_representation format(code, "a", "b", "a"), format(code, "x", "y", "x")
    code = "class C\n  def initialize(@%s : Int32)\n  end\n  def v\n    @%s\n  end\nend"
    assert_same_representation format(code, "a", "a"), format(code, "b", "b")
  end

  def test_methods_named_like_library_methods_are_renamed
    code = "class C\n  def %s\n    1\n  end\nend"
    assert_same_representation format(code, "sum"), format(code, "max")
    assert_same_representation format(code, "to_s"), format(code, "show")
  end
end
