require_relative "stage_helper"

# Checks R's declarations of which nodes are names and which nodes define
# them (see r/representation.rb), through the engine's renaming.
class RNamesTest < Minitest::Test
  include RStages

  def test_renames_variables_functions_and_parameters
    source = "total <- 0\ncount = 1\narea <- function(w, h = 2, ...) { inner <<- w * h }\n3 -> answer"
    assert_equal %w[answer area count h inner total w], renamed(source)
  end

  def test_renames_lambdas_parameters
    assert_equal %w[double x], renamed("double <- \\(x) x * 2")
  end

  def test_renames_the_variables_of_loops
    assert_equal %w[i total], renamed("total <- 0\nfor (i in 1:3) total <- total + i")
  end

  def test_renames_the_fields_that_are_assigned_to
    assert_equal %w[direction robot], renamed("robot <- list()\nrobot$direction <- 'north'\nrobot$direction")
  end

  def test_keeps_the_fields_that_are_only_read
    assert_equal %w[f x], renamed("f <- function(x) x$value")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("f <- function(s) stringr::str_detect(toupper(s), 'A')")
  end

  def test_keeps_argument_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("f <- function(s) paste(s, collapse = '')")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[f s sum], renamed("f <- function(s) { sum <- 1; sum(s) }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], R::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if R::Representation.name?(node) }
    leaves
  end
end
