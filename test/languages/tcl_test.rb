require "test_helper"

# Tests Rosetta as a whole on Tcl solutions. The tests of each stage are in
# test/languages/tcl/.
class TclTest < RosettaTest
  track "tcl"

  def test_comments_and_formatting
    assert_same_representation "#!/usr/bin/env tclsh\n# c\nproc f {x} {\n    return $x ;# x\n}\n",
                               "proc f {x} { return $x }"
    refute_same_representation "proc f {x} { return $x }", "proc f {x} { return x }"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "proc area {w h} { expr {$w * $h} }", "proc size {x y} { expr {$x * $y} }"
    assert_same_representation "proc f {l} { foreach x $l { lappend out $x }; return $out }",
                               "proc f {items} { foreach item $items { lappend result $item }; return $result }"
    refute_same_representation "proc f {a b} { expr {$a * $b} }", "proc f {a b} { expr {$a * $a} }"
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation "proc f {s} { string toupper $s }", "proc f {s} { string tolower $s }"
  end

  def test_imports_are_dropped
    assert_same_representation "package require Tcl 8.6\nset x 1", "set x 1"
    assert_same_representation "namespace import ::tcl::mathop::*\nset x 1", "set x 1"
    refute_same_representation "set x [package names]", "set x 1"
  end

  def test_words_numbers_and_strings_are_their_values
    assert_same_representation 'proc f {} { return "abc" }', "proc f {} { return abc }"
    assert_same_representation "proc f {x} { expr {$x * 0x10} }", "proc f {x} { expr {$x * 16} }"
    refute_same_representation 'proc f {} { return "you" }', 'proc f {} { return "me" }'
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "proc f {x} {"
  end
end
