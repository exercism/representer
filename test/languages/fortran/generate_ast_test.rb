require_relative "stage_helper"

# Tests Fortran's GenerateAST stage. Each assert_same pair gets the same tree
# from a Fortran compiler's parser, and each refute_same pair gets different
# trees.
class FortranGenerateASTTest < Minitest::Test
  include FortranStages

  def test_layout_and_continuations_make_no_difference
    assert_same "x = a + &\n    b\ny = 1; z = 2\n", "x = a + b\ny = 1\nz = 2\n"
    assert_same "integer :: x", "integer x"
  end

  def test_names_and_keywords_ignore_case
    assert_same "Total = SUM(Values)", "total = sum(values)"
    assert_same "IF (X > 1) THEN\n  Y = .TRUE.\nEND IF\n", "if (x > 1) then\n  y = .true.\nend if\n"
    assert_same "x = len(s)", "x = LEN(s)"
  end

  def test_keywords_with_or_without_a_space_are_the_same
    assert_same "double precision :: x", "doubleprecision :: x"
    assert_same "if (a) then\n  x = 1\nelse if (b) then\n  x = 2\nend if\n",
                "if (a) then\n  x = 1\nelseif (b) then\n  x = 2\nendif\n"
    assert_same "do i = 1, 3\n  x = i\nend do\n", "do i = 1, 3\n  x = i\nenddo\n"
  end

  def test_end_statements_make_no_difference
    assert_same "module m\ncontains\n  function f(x)\n    f = x\n  end function f\nend module m\n",
                "module m\ncontains\n  function f(x)\n    f = x\n  end function\nend module\n"
  end

  def test_relational_operators_have_one_spelling
    assert_same "x = a .eq. b .or. a .ne. b", "x = a == b .or. a /= b"
    assert_same "x = a .lt. b .and. a .GE. b", "x = a < b .and. a >= b"
    refute_same "x = a < b", "x = a <= b"
  end

  def test_array_constructors_are_the_same_with_either_brackets
    assert_same "x = (/ 1, 2 /)", "x = [1, 2]"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "x = (a * b) / c", "x = a * b / c"
    assert_same "x = f((a))", "x = f(a)"
    refute_same "x = a - (b - c)", "x = a - b - c"
  end

  def test_a_one_line_if_stays_apart_from_an_if_block
    refute_same "if (a) x = 1", "if (a) then\n  x = 1\nend if\n"
  end

  def test_numbers_are_their_values
    assert_same "x = 007 + 1e3", "x = 7 + 1000.0"
    assert_same "x = 1.5D0", "x = 1.50d0"
    assert_same "x = 2.0_dp", "x = 2._dp"
    refute_same "x = 1", "x = 1.0"
    refute_same "x = 1.0", "x = 1.0d0"
    refute_same "x = 2.0_dp", "x = 2.0_sp"
    refute_same "character :: s*3", "character :: s*5"
  end

  def test_strings_are_their_values
    assert_same "x = 'it''s'", "x = \"it's\""
    assert_same "x = \"say \"\"hi\"\"\"", "x = 'say \"hi\"'"
    refute_same "x = 'a'", "x = 'A'"
    refute_same "x = 'a'", "x = a"
  end

  def test_keywords_that_change_the_meaning_stay
    refute_same "integer, intent(in) :: x", "integer, intent(out) :: x"
    refute_same "do i = 1, 3\n  exit\nend do\n", "do i = 1, 3\n  cycle\nend do\n"
    refute_same "x = a(1:)", "x = a(:1)"
  end

  private
  # Put the source in a program, unless it is a module, because statements
  # can't stand on their own.
  def ast(source)
    source = "program p\n#{source}\nend program\n" unless source.start_with?("module")
    write(generate_ast(source))
  end

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
