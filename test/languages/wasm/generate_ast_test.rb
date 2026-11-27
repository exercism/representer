require_relative "stage_helper"

# Tests WebAssembly's GenerateAST stage. Each assert_same pair is code that
# WebAssembly's text format reads as the same module, ignoring comments and
# spacing, and each refute_same pair is code that it reads differently.
class WasmGenerateASTTest < Minitest::Test
  include WasmStages

  def test_drops_comments
    assert_same wrap("(i32.const 1)"), ";; one\n(; two ;)\n#{wrap("(i32.const 1) ;; three\n")}"
  end

  def test_folded_instructions_are_the_same_as_plain_ones
    assert_same wrap("(i32.add (local.get $a) (i32.const 1))"), wrap("local.get $a\ni32.const 1\ni32.add")
    assert_same wrap("(i32.add (i32.mul (local.get $a) (i32.const 2)) (i32.const 1))"),
                wrap("local.get $a i32.const 2 i32.mul i32.const 1 i32.add")
    refute_same wrap("(i32.sub (local.get $a) (i32.const 1))"), wrap("(i32.sub (i32.const 1) (local.get $a))")
  end

  def test_blocks_and_ifs_can_be_folded
    assert_same wrap("(block $b (br $b))"), wrap("block $b\nbr $b\nend")
    assert_same wrap("(loop $l (br $l))"), wrap("loop $l\nbr $l\nend")
    assert_same wrap("(if (result i32) (local.get $a) (then (i32.const 1)) (else (i32.const 2)))"),
                wrap("local.get $a\nif (result i32)\ni32.const 1\nelse\ni32.const 2\nend")
    assert_same wrap("(if (local.get $a) (then (nop)))"), wrap("local.get $a\nif\nnop\nend")
    refute_same wrap("(if (local.get $a) (then (nop)))"), wrap("(if (local.get $a) (then (nop)) (else (nop)))")
  end

  def test_a_folded_block_can_be_an_operand
    assert_same wrap("(i32.add (block (result i32) (i32.const 1)) (i32.const 2))"),
                wrap("block (result i32)\ni32.const 1\nend\ni32.const 2\ni32.add")
  end

  # The folded form's empty "then" has no list of instructions, so the else
  # branch's list must not become the "then" branch.
  def test_an_if_with_an_empty_then
    empty_then = "(module (func (if (i32.const 1) (then) (else (nop)))))"
    assert_same empty_then, "(module (func i32.const 1 if else nop end))"
    refute_same empty_then, "(module (func (if (i32.const 1) (then (nop)))))"
  end

  def test_an_if_with_an_empty_else
    assert_same wrap("(if (local.get $a) (then (nop)) (else))"), wrap("(if (local.get $a) (then (nop)))")
  end

  # `(if c t)` and `(if c t e)` mean `(if c (then t) (else e))`.
  def test_the_shorthand_if_is_the_same_as_the_spec_form
    assert_same wrap("(if (local.get $a) (nop))"), wrap("(if (local.get $a) (then (nop)))")
    assert_same wrap("(if (local.get $a) (i32.const 1) (i32.const 2))"),
                wrap("(if (local.get $a) (then (i32.const 1)) (else (i32.const 2)))")
    assert_same wrap("(if (result i32) (local.get $a) (i32.const 1) (i32.const 2))"),
                wrap("local.get $a\nif (result i32)\ni32.const 1\nelse\ni32.const 2\nend")
    refute_same wrap("(if (local.get $a) (i32.const 1))"), wrap("(if (local.get $a) (i32.const 2))")
  end

  def test_grouped_parameters_locals_and_results
    assert_same "(module (func (param i32 i32) (result i32 i32) (local i64 i64)))",
                "(module (func (param i32) (param i32) (result i32) (result i32) (local i64) (local i64)))"
    refute_same "(module (func (param i32 i64)))", "(module (func (param i64 i32)))"
  end

  def test_an_inline_export_is_the_same_as_an_export_field
    assert_same "(module (func $f (export \"f\")))", "(module (func $f) (export \"f\" (func $f)))"
    assert_same "(module (func (export \"f\")))", "(module (func) (export \"f\" (func 0)))"
    assert_same "(module (memory (export \"mem\") 1))", "(module (memory 1) (export \"mem\" (memory 0)))"
    refute_same "(module (func $f) (func $g) (export \"f\" (func $f)))", "(module (func $f) (func $g) (export \"f\" (func $g)))"
  end

  def test_keeps_the_names_of_exports
    refute_same "(module (func (export \"f\")))", "(module (func (export \"g\")))"
    refute_same "(module (memory (export \"mem\") 1))", "(module (memory (export \"memory\") 1))"
  end

  def test_a_function_type_without_a_name_is_dropped
    assert_same "(module (type (func (param i32))) (func (param i32)))", "(module (func (param i32)))"
    refute_same "(module (type (func (param i32))) (func (type 0)))", "(module (func (type 0)))"
  end

  def test_strings_are_their_bytes
    assert_same "(module (data (i32.const 0) \"a\\n\"))", "(module (data (i32.const 0) \"a\\0a\"))"
    assert_same "(module (data (i32.const 0) \"A\"))", "(module (data (i32.const 0) \"\\u{41}\"))"
    refute_same "(module (data (i32.const 0) \"a\"))", "(module (data (i32.const 0) \"b\"))"
  end

  def test_numbers_are_their_values
    assert_same wrap("(i32.const 1_000)"), wrap("(i32.const 1000)")
    assert_same wrap("(i32.load offset=1_000 (local.get $a))"), wrap("(i32.load offset=1000 (local.get $a))")
    refute_same wrap("(i32.const 1)"), wrap("(i32.const 2)")
    refute_same wrap("(i32.const 1)"), wrap("(i64.const 1)")
  end

  def test_constants_are_their_values_in_their_type
    assert_same wrap("(f32.const 1) (drop) (local.get $a)"), wrap("(f32.const 1.0) (drop) (local.get $a)")
    assert_same wrap("(f64.const 1.50) (drop) (local.get $a)"), wrap("(f64.const 1.5) (drop) (local.get $a)")
    assert_same wrap("(i64.const 18446744073709551615) (drop) (local.get $a)"), wrap("(i64.const -1) (drop) (local.get $a)")
    assert_same wrap("(i32.const 0x1F)"), wrap("(i32.const 31)")
    refute_same wrap("(i32.const 4294967295)"), wrap("(i32.const 4294967294)")
    refute_same wrap("(i32.const 1)"), wrap("(i32.const 2)")
  end

  def test_fields_without_a_module_are_a_module
    body = "(func $f (export \"f\") (param $a i32) (result i32) (local.get $a))"
    assert_same "(module #{body})", body
    refute_same "(module $m #{body})", body
  end

  private
  def wrap(body) = "(module (func $f (export \"f\") (param $a i32) (result i32)\n#{body}))"
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
