require "test_helper"

# Tests Rosetta as a whole on x86-64 assembly solutions. The tests of each
# stage are in test/languages/x86_64_assembly/.
class X8664AssemblyTest < RosettaTest
  track "x86-64-assembly"

  def test_comments_and_formatting
    assert_same_representation "; c\nf:  mov rax, 1 ; one\n    ret\n", "f: mov rax,1\nret"
    refute_same_representation "f: mov rax, 1\nret", "f: mov rax, 2\nret"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "global leap\nleap: test edi, 3\njz done\ndone: ret",
                               "global year\nyear: test edi, 3\njz out\nout: ret"
    assert_same_representation "section .data\nmsg db 'hi', 0\nlen equ $ - msg",
                               "section .data\ntext db 'hi', 0\nsize equ $ - text"
    refute_same_representation "f: add rax, 1", "f: add rbx, 1"
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation "extern printf\nf: call printf", "extern puts\nf: call puts"
  end

  def test_includes_are_dropped
    assert_same_representation "%include \"debug.mac\"\nf: ret", "f: ret"
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f: mov rax, [[rbx"
  end
end
