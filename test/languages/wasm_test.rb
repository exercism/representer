require "test_helper"

class WasmTest < InspectorTest
  extend UpstreamTests

  track "wasm"

  # Every fixture mapping is empty. Inspector renames each `$name` that the
  # solution chooses, so every mapping gains the leap solution's parameter.
  RENAMES = "Inspector renames every `$name` the solution chooses, here the parameter.".freeze

  DEVIATIONS = %w[sugared unsugared normalize-whitespace remove-comments].to_h do |name|
    [name, { add: ["year"], why: RENAMES }]
  end.freeze

  # The equivalent files are wat-desugar's output, unchanged. It writes a
  # function's export as a separate field, adds a `(type ...)` field for the
  # function's type, and numbers the function in a comment, and each of those
  # has a rule here.
  upstream_tests ".wat", deviations: DEVIATIONS

  # The old test with a solution file and three other files. Its config says
  # that two of them (editor.wat and invalidator.wat) aren't solution files,
  # and the website only sends solution files, so those two aren't ported.
  # The test has the other two input files, an equivalent file for each, and
  # the old mapping.
  Dir[File.join(__dir__, "..", "fixtures", "wasm-multi-file", "*")].sort.each do |dir|
    define_method("test_upstream_#{File.basename(dir)}") do
      inputs = Dir[File.join(dir, "*.wat")].to_h { |path| [File.basename(path), File.read(path)] }
      equivalents = Dir[File.join(dir, "equivalent", "*.wat")].to_h { |path| [File.basename(path), File.read(path)] }
      assert_equal inputs.keys.sort, equivalents.keys.sort

      actual = Inspector::RepresentSolution.("wasm", inputs)
      assert_equal Inspector::RepresentSolution.("wasm", equivalents).representation, actual.representation
      assert_equal ["year"], actual.mapping.values.uniq
    end
  end

  def test_names_the_solution_chooses_are_renamed
    assert_same_representation "(module (func $f (export \"f\") (param $a i32) (result i32) (local.get $a)))",
      "(module (func $g (export \"f\") (param $b i32) (result i32) (local.get $b)))"
    assert_same_representation "(module (global $x (mut i32) (i32.const 0)) (func (global.set $x (i32.const 1))))",
      "(module (global $y (mut i32) (i32.const 0)) (func (global.set $y (i32.const 1))))"
  end

  def test_a_syntax_error_gets_a_basic_representation
    assert_basic_representation "(module (func"
  end
end
