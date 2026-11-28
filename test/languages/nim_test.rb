require "test_helper"

# Ported from exercism/nim-representer: its golden test (example-two-fer), the
# end-to-end tests in tests/tnormalizations.nim ("All the things", "No params,
# return type or statements", "Just one let statement", "All features" and the
# two fmt tests) and the name tests in tests/tmapping.nim (see
# NimGenerateASTTest#test_names_ignore_case_after_the_first_letter_and_underscores).
# The old tests compared the printed code, so each equivalent.nim is the old
# expected output.
#
# The old unit tests only counted the names in all-features, so its expected
# mapping lists the names found in the input and its equivalent.nim was
# written by hand.
class NimTest < InspectorTest
  extend UpstreamTests

  track "nim"

  ONE_SPELLING = "Nim reads every spelling of a name the same way after its first letter, so the mapping " \
                 "gives each name in one spelling: its first letter as written, and the rest in lower case " \
                 "without underscores.".freeze

  DEVIATIONS = {
    "all-features" => {
      add: %w[Dollar testmacro testproc testtemplate],
      remove: %w[testMacro testProc testTemplate],
      why: "The old representer left type sections as written, so it didn't rename the type Dollar. Inspector " \
           "renames it. #{ONE_SPELLING}"
    },
    "all-the-things" => {
      add: %w[fullname helloworld teststdout],
      remove: %w[fullName helloWorld testStdout],
      why: ONE_SPELLING
    },
    "example-two-fer" => { add: ["twofer"], remove: ["twoFer"], why: ONE_SPELLING },
    "fmt-strings" => { add: ["twofer"], remove: ["twoFer"], why: ONE_SPELLING },
    "fmt-strings-ampersand" => { add: ["twofer"], remove: ["twoFer"], why: ONE_SPELLING },
    "no-params" => { add: ["helloworld"], remove: ["helloWorld"], why: ONE_SPELLING }
  }.freeze

  upstream_tests ".nim", deviations: DEVIATIONS

  def test_names_are_renamed_wherever_they_appear
    assert_same_representation "proc hello_world(a: int): int = a\necho helloWorld(1)",
      "proc helloworld(a: int): int = a\necho hELLOWORLD(1)"
    assert_same_representation "let a = 1\nvar b = a", "let c = 1\nvar d = c"
    assert_same_representation "type Dollar = object\n  amount: int\nlet p = Dollar(amount: 1)\necho p.amount",
      "type Euro = object\n  value: int\nlet p = Euro(value: 1)\necho p.value"
    assert_same_representation "proc f(name: int): int = name\necho f(name = 1)", "proc f(who: int): int = who\necho f(who = 1)"
  end

  def test_library_names_are_kept
    refute_same_representation "echo toUpper(\"a\")", "echo toLower(\"a\")"
    assert_same_representation "echo toUpper(\"a\")", "echo to_upper(\"a\")"
    refute_same_representation "proc f(a: seq[int]): int = a.len", "proc f(a: seq[int]): int = a.high"
    refute_same_representation "proc f(): int = result", "proc f(): int = 1"
  end

  def test_library_names_the_solution_defines_are_renamed
    assert_same_representation "proc sum(a: seq[int]): int = a.sum", "proc max(a: seq[int]): int = a.max"
  end

  def test_the_mapping_gives_each_name_in_one_spelling
    assert_equal %w[helloworld a], represent("proc helloWorld(a: int): int = a\necho hello_WORLD(1)").mapping.values
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "proc f( =\n"
  end
end
