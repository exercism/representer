require "test_helper"

class WasmTest < RepresenterTest
  extend UpstreamTests

  track "wasm"

  # The old representer renamed nothing, so every old mapping is empty. This
  # representer renames each `$name` that the solution chooses, so every
  # mapping gains the leap solution's parameter.
  RENAMES = "The old representer never renamed anything. This representer renames every `$name` the solution " \
            "chooses, here the parameter.".freeze

  DEVIATIONS = %w[sugared unsugared normalize-whitespace remove-comments].to_h do |name|
    [name, { add: %w[year], why: RENAMES }]
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

      actual = Representer::RepresentSolution.("wasm", inputs, {})
      assert_equal Representer::RepresentSolution.("wasm", equivalents, {}).representation, actual.representation
      assert_equal %w[year], actual.mapping.values.uniq
    end
  end

  def wrap(body) = "(module (func $f (export \"f\") (param $a i32) (result i32)\n#{body}))"

  def test_comments_are_dropped
    assert_same_representation wrap("(i32.const 1)"), ";; one\n(; two ;)\n#{wrap("(i32.const 1) ;; three\n")}"
  end

  def test_folded_instructions_are_the_same_as_plain_ones
    assert_same_representation wrap("(i32.add (local.get $a) (i32.const 1))"), wrap("local.get $a\ni32.const 1\ni32.add")
    assert_same_representation wrap("(i32.add (i32.mul (local.get $a) (i32.const 2)) (i32.const 1))"),
      wrap("local.get $a i32.const 2 i32.mul i32.const 1 i32.add")
    refute_same_representation wrap("(i32.sub (local.get $a) (i32.const 1))"), wrap("(i32.sub (i32.const 1) (local.get $a))")
  end

  def test_blocks_and_ifs_can_be_folded
    assert_same_representation wrap("(block $b (br $b))"), wrap("block $b\nbr $b\nend")
    assert_same_representation wrap("(loop $l (br $l))"), wrap("loop $l\nbr $l\nend")
    assert_same_representation wrap("(if (result i32) (local.get $a) (then (i32.const 1)) (else (i32.const 2)))"),
      wrap("local.get $a\nif (result i32)\ni32.const 1\nelse\ni32.const 2\nend")
    assert_same_representation wrap("(if (local.get $a) (then (nop)))"), wrap("local.get $a\nif\nnop\nend")
    refute_same_representation wrap("(if (local.get $a) (then (nop)))"), wrap("(if (local.get $a) (then (nop)) (else (nop)))")
  end

  def test_names_the_solution_chooses_are_renamed
    assert_same_representation wrap("(local.get $a)"), "(module (func $g (export \"f\") (param $b i32) (result i32) (local.get $b)))"
    assert_same_representation "(module (global $x (mut i32) (i32.const 0)) (func (global.set $x (i32.const 1))))",
      "(module (global $y (mut i32) (i32.const 0)) (func (global.set $y (i32.const 1))))"
    refute_same_representation wrap("(local.get $a)"), wrap("(i32.const 0)")
  end

  def test_exports_are_not_renamed
    refute_same_representation "(module (func (export \"f\")))", "(module (func (export \"g\")))"
    refute_same_representation "(module (memory (export \"mem\") 1))", "(module (memory (export \"memory\") 1))"
  end

  def test_an_inline_export_is_the_same_as_an_export_field
    assert_same_representation "(module (func $f (export \"f\")))", "(module (func $f) (export \"f\" (func $f)))"
    assert_same_representation "(module (func (export \"f\")))", "(module (func) (export \"f\" (func 0)))"
    assert_same_representation "(module (memory (export \"mem\") 1))", "(module (memory 1) (export \"mem\" (memory 0)))"
    refute_same_representation "(module (func $f) (func $g) (export \"f\" (func $f)))",
      "(module (func $f) (func $g) (export \"f\" (func $g)))"
  end

  def test_grouped_parameters_locals_and_results
    assert_same_representation "(module (func (param i32 i32) (result i32 i32) (local i64 i64)))",
      "(module (func (param i32) (param i32) (result i32) (result i32) (local i64) (local i64)))"
    refute_same_representation "(module (func (param i32 i64)))", "(module (func (param i64 i32)))"
  end

  def test_strings_are_their_bytes
    assert_same_representation "(module (data (i32.const 0) \"a\\n\"))", "(module (data (i32.const 0) \"a\\0a\"))"
    assert_same_representation "(module (data (i32.const 0) \"A\"))", "(module (data (i32.const 0) \"\\u{41}\"))"
    refute_same_representation "(module (data (i32.const 0) \"a\"))", "(module (data (i32.const 0) \"b\"))"
  end

  def test_numbers
    assert_same_representation wrap("(i32.const 1_000)"), wrap("(i32.const 1000)")
    refute_same_representation wrap("(i32.const 1)"), wrap("(i32.const 2)")
    refute_same_representation wrap("(i32.const 1)"), wrap("(i64.const 1)")
  end

  def test_a_syntax_error_is_unrepresentable
    assert_unrepresentable "(module (func"
  end
end
