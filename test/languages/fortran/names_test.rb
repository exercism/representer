require_relative "stage_helper"

# Checks Fortran's declarations of which nodes are names and which nodes
# define them (see fortran/representation.rb), through the engine's
# renaming.
class FortranNamesTest < Minitest::Test
  include FortranStages

  def test_renames_modules_functions_subroutines_parameters_and_results
    source = <<~FORTRAN
      module Leap
      contains
        function is_leap(year) result(answer)
          integer :: year
          logical :: answer
          answer = mod(year, 4) == 0
        end function
        subroutine show(x)
          integer :: x
          print *, x
        end subroutine
      end module
    FORTRAN
    assert_equal %w[answer is_leap leap show x year], renamed(source)
  end

  def test_renames_variables_constants_and_arrays
    source = <<~FORTRAN
      program p
        integer, parameter :: Limit = 4
        integer :: total = 0, counts(10)
        integer, pointer :: q => null()
        undeclared = 1
        counts(1) = limit
      end program
    FORTRAN
    assert_equal %w[counts limit p q total undeclared], renamed(source)
  end

  def test_renames_types_components_and_type_bound_procedures
    source = <<~FORTRAN
      module shapes
        type :: circle
          real :: radius
        contains
          procedure :: area => circle_area
        end type
      contains
        real function circle_area(c)
          class(circle) :: c
          circle_area = c%radius ** 2
        end function
      end module
    FORTRAN
    assert_equal %w[area c circle circle_area radius shapes], renamed(source)
  end

  def test_renames_interfaces_associations_and_labels
    source = <<~FORTRAN
      module m
        interface norm
          module procedure norm2d
        end interface
      contains
        subroutine run(v)
          real :: v(2)
          outer: do
            associate (first => v(1))
              exit outer
            end associate
          end do outer
        end subroutine
      end module
    FORTRAN
    assert_equal %w[first m norm norm2d outer run v], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = <<~FORTRAN
      module m
        use iso_fortran_env, only: int64
      contains
        integer function f(s)
          character(len=*) :: s
          f = len_trim(adjustl(s)) + huge(1_int64)
        end function
      end module
    FORTRAN
    assert_equal %w[f m s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Fortran::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Fortran::Representation.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
