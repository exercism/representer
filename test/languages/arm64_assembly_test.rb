require "test_helper"

# Tests Rosetta as a whole on ARM64 assembly solutions. The tests of each
# stage are in test/languages/arm64_assembly/.
class Arm64AssemblyTest < RosettaTest
  track "arm64-assembly"

  def test_comments_and_formatting
    assert_same_representation "// c\n# c\nf:  mov x0, #1 /* one */\n    ret\n", "f: mov x0,#1\nret"
    refute_same_representation "f: mov x0, #1\nret", "f: mov x0, #2\nret"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation ".globl leap\nleap: cbz x0, done\ndone: ret", ".globl year\nyear: cbz x0, out\nout: ret"
    assert_same_representation "n .req x0\nf: add n, n, 1", "count .req x0\nf: add count, count, 1"
    refute_same_representation "f: add x0, x0, 1", "f: add x1, x1, 1"
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation "f: bl printf", "f: bl puts"
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f: mov x0, [[x1"
  end
end
