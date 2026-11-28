require_relative "stage_helper"

# Tests ARM64 assembly's GenerateAST stage, which gives one tree to code that
# differs only in layout and the spellings that the assembler reads the same
# way.
class Arm64AssemblyGenerateASTTest < Minitest::Test
  include Arm64AssemblyStages

  def test_drops_layout
    assert_same "mov x0, #1; ret", "mov   x0,#1\nret"
    assert_same "loop: b loop", "loop:\n  b loop"
  end

  def test_immediates_are_the_same_with_or_without_their_hash
    assert_same "mov x0, #1", "mov x0, 1"
    assert_same "ldr x1, [x0, #8]", "ldr x1, [x0, 8]"
    assert_same "add x0, x0, #(1 << 4)", "add x0, x0, 1 << 4"
    refute_same "mov x0, #1", "mov x0, #2"
    refute_same "ldr x0, =1", "mov x0, #1"
  end

  def test_numbers_are_their_values
    assert_same "mov x0, #0x1F", "mov x0, #31"
    assert_same "mov x0, #0b101", "mov x0, #5"
    assert_same "mov x0, #010", "mov x0, #8"
    refute_same "mov x0, #10", "mov x0, #8"
  end

  def test_strings_are_their_values
    assert_same "s: .asciz \"a\\tb\"", "s: .asciz \"a\tb\""
    refute_same "s: .asciz \"a\\n\"", "s: .asciz \"a\""
    refute_same "s: .asciz \"a\\x41\"", "s: .asciz \"aA\""
    refute_same "s: .asciz \"a\"", "s: .asciz \"b\""
  end

  def test_chars_are_the_same_with_or_without_their_closing_quote
    assert_same "mov w0, #'a", "mov w0, #'a'"
    refute_same "mov w0, #'a'", "mov w0, #97"
    refute_same "mov w0, #'a'", "mov w0, #'b'"
  end

  def test_equ_set_and_equals_are_the_same_definition
    assert_same ".equ SIZE, 8", ".set SIZE, 8"
    assert_same ".equ SIZE, 8", "SIZE = 8"
    refute_same ".equ SIZE, 8", ".eqv SIZE, 8"
  end

  def test_global_and_globl_are_the_same_directive
    assert_same ".global main", ".globl main"
    refute_same ".globl main", ".text main"
  end

  def test_mnemonics_registers_and_operators_ignore_case
    assert_same "MOV X0, X1, LSL #2", "mov x0, x1, lsl #2"
    assert_same "B.EQ done", "b.eq done"
    assert_same "csel x0, x1, x2, EQ", "csel x0, x1, x2, eq"
    refute_same "loop: b loop", "LOOP: b LOOP"
  end

  def test_macro_uses_are_calls
    macro = ".macro LOAD reg\n  ldr \\reg, [x0]\n.endm\n"
    assert_includes ast("#{macro}LOAD x1"), "(macro_call LOAD x1)"
    assert_includes ast("#{macro}load x1"), "(instruction load x1)"
  end

  def test_local_label_references_split_into_label_and_direction
    assert_includes ast("1: b 1b"), "(local_label_reference 1 b)"
    refute_same "1: b 1b", "1: b 1f"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
