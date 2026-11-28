require "test_helper"

# Tests Rosetta as a whole on Red solutions. The tests of each stage are in
# test/languages/red/.
class RedTest < RosettaTest
  track "red"

  def test_comments_and_formatting
    assert_same_representation "f: func [a] [ ; c\n  a ]", "f: func [a] [a]"
    refute_same_representation "f: func [a] [a + 1]", "f: func [a] [a - 1]"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "total: 0\nprint total", "sum: 0\nprint sum"
    assert_same_representation "double: func [n] [n * 2]\nprint double 3", "twice: func [x] [x * 2]\nprint twice 3"
    assert_same_representation "foreach c \"ab\" [print c]", "foreach x \"ab\" [print x]"
    assert_same_representation "repeat i 3 [print i]", "repeat j 3 [print j]"
  end

  def test_object_fields_and_paths
    assert_same_representation "p: make object! [x: 1]\nprint p/x", "q: make object! [y: 1]\nprint q/y"
  end

  def test_library_words_are_kept
    refute_same_representation "print reverse \"ab\"", "print uppercase \"ab\""
  end

  def test_strings_and_refinements_keep_their_text
    refute_same_representation "print \"a\"", "print \"b\""
    refute_same_representation "f: func [a /local b] [b: a]", "f: func [a /extra b] [b: a]"
  end

  def test_chars_urls_and_binaries_keep_their_text
    refute_same_representation "print #\"a\"", "print #\"b\""
    refute_same_representation "print http://a.com", "print http://b.com"
    refute_same_representation "print \#{FF}", "print \#{00}"
  end

  def test_main_is_renamed_as_any_other_name
    assert_same_representation "main: does [1]", "other: does [1]"
  end

  def test_numbers_are_their_values
    assert_same_representation "Red []\nx: 1'000 + 1.50", "Red []\nx: 1000 + 1.5"
    refute_same_representation "Red []\nx: 1.0", "Red []\nx: 1"
  end
end
