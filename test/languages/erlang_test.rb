require "test_helper"

class ErlangTest < RosettaTest
  track "erlang"

  def test_comments_and_layout_are_ignored
    assert_same_representation "-module(a).\n%% Says one.\nf() ->\n    1. % one\n",
      "-module(a).\nf() -> 1.\n"
  end

  def test_imports_are_dropped
    assert_same_representation "-module(a).\n-import(lists, [sort/1]).\n-include_lib(\"eunit/include/eunit.hrl\").\n" \
                               "-include(\"a.hrl\").\nf(L) -> sort(L).\n",
      "-module(a).\nf(L) -> sort(L).\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "-module(leap).\n-export([leap_year/1]).\nleap_year(Year) -> by(Year, 4).\nby(Y, N) -> Y rem N == 0.\n",
      "-module(l).\n-export([is_leap/1]).\nis_leap(Y) -> d(Y, 4).\nd(A, B) -> A rem B == 0.\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "-module(a).\nf(L) -> lists:max(L).\n", "-module(a).\nf(L) -> lists:min(L).\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "-module(a).\nf(X) -> X + 1.\n", "-module(a).\nf(X) -> X - 1.\n"
    refute_same_representation "-module(a).\nf(A, B) -> A - B.\n", "-module(a).\nf(A, B) -> B - A.\n"
    refute_same_representation "-module(a).\nf(X, X) -> X.\n", "-module(a).\nf(_, _) -> 1.\n"
    refute_same_representation "-module(a).\nf(X) -> X =:= 1.\n", "-module(a).\nf(X) -> X == 1.\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "-module(a).\nf( -> .\n"
  end
end
