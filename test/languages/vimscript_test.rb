require "test_helper"

class VimscriptTest < RosettaTest
  track "vimscript"

  def test_comments_and_layout_are_ignored
    assert_same_representation "\" Says one.\nfunction! F() abort\n  return 1 \" one\nendfunction\n",
      "function! F() abort\nreturn 1\nendfunction\n"
  end

  def test_imports_are_dropped
    assert_same_representation "source helpers.vim\nruntime plugin/helpers.vim\nlet x = 1\n", "let x = 1\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "function! LeapYear(year) abort\n  return a:year % 4 == 0\nendfunction\n",
      "function! IsLeap(y) abort\n  return a:y % 4 == 0\nendfunction\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "function! F(s)\n  return toupper(a:s)\nendfunction\n",
      "function! F(s)\n  return tolower(a:s)\nendfunction\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "let r = a + 1\n", "let r = a - 1\n"
    refute_same_representation "let r = a - b\n", "let r = b - a\n"
    refute_same_representation "function! F() abort\nendfunction\n", "function! F()\nendfunction\n"
    refute_same_representation "function! F()\nendfunction\n", "function F()\nendfunction\n"
  end

  def test_vim9_script_gets_basics_representation
    assert_basic_representation "vim9script\ndef g:F(): number\n  return 1\nenddef\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "let x = (\n"
  end
end
