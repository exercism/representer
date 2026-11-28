require_relative "stage_helper"

# Tests x86-64 assembly's GenerateAST stage, which gives one tree to code that
# differs only in layout and the spellings that NASM reads the same way.
class X8664AssemblyGenerateASTTest < Minitest::Test
  include X8664AssemblyStages

  def test_drops_layout
    assert_same "mov rax, 1\nret", "mov   rax,1\n\n  ret"
    assert_same "loop: jmp loop", "loop:\n  jmp loop"
    assert_same "pop rax,", "pop rax"
  end

  def test_numbers_are_their_values
    assert_same "mov rax, 0x1F", "mov rax, 31"
    assert_same "mov rax, 0h1F", "mov rax, 31"
    assert_same "mov rax, $1F", "mov rax, 31"
    assert_same "mov rax, 1Fh", "mov rax, 31"
    assert_same "mov rax, 0Ah", "mov rax, 10"
    assert_same "mov rax, 0b101", "mov rax, 5"
    assert_same "mov rax, 101b", "mov rax, 5"
    assert_same "mov rax, 0o17", "mov rax, 15"
    assert_same "mov rax, 17q", "mov rax, 15"
    assert_same "mov rax, 0d10", "mov rax, 10"
    assert_same "mov rax, 1_000", "mov rax, 1000"
    refute_same "mov rax, 010", "mov rax, 8"
    refute_same "mov rax, 10", "mov rax, 16"
  end

  def test_strings_are_their_values
    assert_same "db 'hi', 0", "db \"hi\", 0"
    assert_same "db `hi`, 0", "db 'hi', 0"
    refute_same "db `hi\\n`", "db 'hi\\n'"
    refute_same "db 'hi'", "db 'ho'"
    refute_same "mov al, 'a'", "mov al, 97"
  end

  def test_brackets_that_only_group_are_unwrapped
    assert_same "mov rax, (1 + 2)", "mov rax, 1 + 2"
    refute_same "mov rax, (1 + 2) * 3", "mov rax, 1 + 2 * 3"
  end

  def test_a_label_before_a_definition_is_its_name
    assert_same "msg: db 'hi'", "msg db 'hi'"
    assert_same "msg:\n  db 'hi'", "msg db 'hi'"
    assert_same "SIZE: equ 8", "SIZE equ 8"
    refute_same "msg: db 'hi'", "msg: mov rax, 1"
  end

  def test_segment_is_section
    assert_same "segment .data", "section .data"
    refute_same "section .data", "section .text"
  end

  def test_mnemonics_registers_and_keywords_ignore_case
    assert_same "MOV RAX, QWORD [RBX]", "mov rax, qword [rbx]"
    assert_same "SECTION .text\nGLOBAL f", "section .text\nglobal f"
    refute_same "loop: jmp loop", "LOOP: jmp LOOP"
  end

  def test_preprocessor_arguments_drop_their_layout
    assert_same "%ifidn  __OUTPUT_FORMAT__, elf64\n%endif", "%ifidn __OUTPUT_FORMAT__,elf64\n%endif"
    refute_same "%ifidn __OUTPUT_FORMAT__,elf64\n%endif", "%ifidn __OUTPUT_FORMAT__,macho64\n%endif"
    refute_same "%error \"a  b\"", "%error \"a b\""
  end

  def test_macro_uses_are_calls
    macro = "%macro PUSHALL 1\n  push %1\n%endmacro\n"
    assert_includes ast("#{macro}PUSHALL rax"), "(macro_call PUSHALL"
    assert_includes ast("#{macro}pushall rax"), "(instruction pushall"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
