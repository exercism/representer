require "test_helper"

class FortranTest < RepresenterTest
  track "fortran"

  def test_comments_and_layout_are_ignored
    commented = <<~FORTRAN
      ! Says hello.
      module m
      contains
        integer function f(x)
          integer :: x ! the input
          f = x + &
              1
        end function f
      end module m
    FORTRAN
    plain = <<~FORTRAN
      module m
      contains
        integer function f(x)
          integer :: x
          f = x + 1
        end function
      end module
    FORTRAN
    assert_same_representation commented, plain
  end

  def test_imports_are_dropped
    assert_same_representation "module m\n  use iso_fortran_env\n  implicit none\nend module\n",
                               "module m\n  implicit none\nend module\n"
  end

  def test_names_the_solution_defines_are_renamed_whatever_their_case
    first = <<~FORTRAN
      module leap
      contains
        logical function is_leap_year(year)
          integer :: year
          is_leap_year = MOD(Year, 4) == 0
        end function
      end module
    FORTRAN
    second = <<~FORTRAN
      module leap
      contains
        logical function check(y)
          integer :: y
          check = mod(y, 4) == 0
        end function
      end module
    FORTRAN
    assert_same_representation first, second
  end

  def test_names_from_outside_are_kept
    refute_same_representation program("print *, len('a')"), program("print *, len_trim('a')")
  end

  def test_things_that_must_stay_apart
    refute_same_representation program("x = 1 + 2"), program("x = 1 - 2")
    refute_same_representation program("x = a .and. b"), program("x = a .or. b")
    refute_same_representation program("x = 'a'"), program("x = 'b'")
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "module m\n  x = (\nend module\n"
  end

  private
  def program(statement) = "program p\n  #{statement}\nend program\n"
end
