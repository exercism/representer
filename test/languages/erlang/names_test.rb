require_relative "stage_helper"

# Checks Erlang's declarations of which nodes are names and which nodes
# define them (see erlang/representation.rb), through the engine's
# renaming.
class ErlangNamesTest < Minitest::Test
  include ErlangStages

  def test_renames_the_module_functions_and_variables
    source = "-module(leap).\n-export([leap_year/1]).\nleap_year(Year) -> divides(Year, 4).\ndivides(A, B) -> A rem B == 0.\n"
    assert_equal %w[A B Year divides leap leap_year], renamed(source)
  end

  def test_renames_the_variables_in_patterns_and_funs
    source = in_module("f({X, [H | T]} = All) ->\n    F = fun(Z) -> Z end,\n    [Q || Q <- T],\n" \
                       "    case X of {ok, V} -> V; _ -> H end,\n    F(All).")
    assert_equal %w[All F H Q T V X Z f leap], renamed(source)
  end

  def test_renames_records_fields_types_and_macros
    source = in_module("-define(LIMIT, 10).\n-record(account, {balance = 0}).\n-type amount() :: integer().\n" \
                       "f(#account{balance = B}) -> B + ?LIMIT.")
    assert_equal %w[B LIMIT account amount balance f leap], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = in_module("f(L) -> lists:map(fun erlang:abs/1, L) ++ ?MODULE_STRING.")
    assert_equal %w[L f leap], renamed(source)
  end

  def test_keeps_the_wildcard
    assert_equal %w[f leap], renamed(in_module("f(_) -> ok."))
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Erlang::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Erlang::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
