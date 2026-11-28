require_relative "stage_helper"

# Tests Tcl's GenerateAST stage, which gives one tree to code that differs
# only in comments, layout and the spellings that Tcl's parser reads the
# same way.
class TclGenerateASTTest < Minitest::Test
  include TclStages

  def test_drops_comments_and_layout
    assert_same "# c\nset x 1 ;# x\n", "set x   1"
    assert_same "set a 1; set b 2", "set a 1\nset b 2"
    assert_same "puts a \\\n  b", "puts a b"
  end

  def test_words_are_their_values_where_nothing_is_substituted
    assert_same 'puts "abc"', "puts abc"
    assert_same "set x {abc}", "set x abc"
    assert_same 'set x {a b}', 'set x "a b"'
    assert_same 'set x {}', 'set x ""'
    assert_same 'return {}', 'return ""'
    assert_same 'set x {$a}', 'set x "\\$a"'
    assert_same 'puts a\\ b', 'puts "a b"'
    refute_same 'set x "$a"', 'set x {$a}'
    refute_same 'puts "a"', 'puts "b"'
    refute_same 'set x {a  b}', 'set x {a b}'
  end

  def test_escapes_are_their_characters
    assert_same "puts \"a\\tb\"", "puts \"a\tb\""
    assert_same 'puts "\-"', "puts -"
    assert_same "puts \\-", "puts -"
    refute_same 'puts "\d"', 'puts "\\\\d"'
    refute_same "regexp \\d $s", "regexp {\\d} $s"
    assert_same 'regexp {\d} $s', 'regexp "\\\\d" $s'
    refute_same 'puts "\\x41"', "puts A"
    refute_same 'puts "\\u00e9"', 'puts "\\u00e8"'
  end

  def test_the_parts_of_a_word_stay_one_word
    assert_same 'puts a$b', 'puts "a$b"'
    assert_same 'puts "$b"', "puts $b"
    assert_same 'puts ${b}', "puts $b"
    refute_same "puts a$b", "puts a $b"
    refute_same "puts $a$b", "puts $a $b"
    refute_same 'puts "a $b"', "puts a $b"
  end

  def test_names_with_namespaces_keep_their_whole_text
    refute_same "puts $::x", "puts $::y"
    refute_same "puts $::x", "puts $x"
  end

  def test_expansion_stays_with_its_word
    refute_same "list {*}$a", "list $a"
    refute_same "list {*}$a $b", "list $a {*}$b"
  end

  def test_keeps_braced_and_unbraced_expressions_apart
    refute_same "expr {$a + 1}", "expr $a + 1"
    refute_same "if {$a} {b}", "if $a {b}"
  end

  def test_brackets_that_only_group_in_expressions_are_dropped
    assert_same "expr {($a + 1) * 2}", "expr {(($a + 1)) * 2}"
    refute_same "expr {($a + 1) * 2}", "expr {$a + 1 * 2}"
  end

  def test_numbers_in_expressions_are_their_values
    assert_same "expr {$a + 0x10}", "expr {$a + 16}"
    assert_same "expr {$a * 1e3}", "expr {$a * 1000.0}"
    assert_same "expr {$a * .5}", "expr {$a * 0.5}"
    refute_same "expr {$a / 2}", "expr {$a / 2.0}"
  end

  def test_booleans_in_expressions_stay_apart
    refute_same "expr {$a && true}", "expr {$a && false}"
    refute_same "expr {!true}", "expr {!false}"
  end

  def test_then_and_else_are_optional
    assert_same "if {$a} then {b} else {c}", "if {$a} {b} {c}"
    assert_same "if {$a} {b} elseif {$c} then {d}", "if {$a} {b} elseif {$c} {d}"
  end

  def test_a_list_of_one_name_needs_no_braces
    assert_same "proc f a {}", "proc f {a} {}"
    assert_same "foreach x $l {}", "foreach {x} $l {}"
    assert_same "proc f {{a}} {}", "proc f {a} {}"
    refute_same "proc f {a {b 1}} {}", "proc f {a b} {}"
  end

  def test_keeps_scripts_and_strings_apart
    refute_same "puts {a b}", "puts a b"
    refute_same "set x {a b}", "set x {a; b}"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
