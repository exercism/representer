require "test_helper"

class PrologTest < RosettaTest
  track "prolog"

  def test_comments_and_layout_are_ignored
    assert_same_representation "%% Says one.\nf(X) :-\n    X = 1. % one\n/* The end */\n",
      "f(X) :- X = 1.\n"
  end

  def test_imports_are_dropped
    assert_same_representation ":- use_module(library(lists)).\n:- use_module(library(apply), [maplist/3]).\n" \
                               ":- ensure_loaded(library(dcg/basics)).\nf(L, M) :- max_list(L, M).\n",
      "f(L, M) :- max_list(L, M).\n"
  end

  def test_other_directives_stay
    refute_same_representation ":- set_prolog_flag(double_quotes, chars).\nf(\"a\").\n", "f(\"a\").\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "leap(Year) :- by(Year, 4).\nby(Y, N) :- Y mod N =:= 0.\n",
      "is_leap(Y) :- d(Y, 4).\nd(A, B) :- A mod B =:= 0.\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "f(L, M) :- max_list(L, M).\n", "f(L, M) :- min_list(L, M).\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "f(X, Y) :- Y is X + 1.\n", "f(X, Y) :- Y is X - 1.\n"
    refute_same_representation "f(A, B, C) :- C is A - B.\n", "f(A, B, C) :- C is B - A.\n"
    refute_same_representation "f(X, X).\n", "f(_, _).\n"
    refute_same_representation "f(X) :- g(X), !.\n", "f(X) :- g(X).\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "f(X) :- .\n"
  end
end
