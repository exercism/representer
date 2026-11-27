require_relative "stage_helper"

# Tests JavaScript's GenerateAST stage. Each assert_same pair gets the same
# tree from JavaScript's parser (ESTree, ignoring locations, comments and
# the raw text of literals), and each refute_same pair gets different trees.
# The last test lists the pairs where this stage deliberately differs from
# the parser.
class JavascriptGenerateASTTest < Minitest::Test
  include JavascriptStages

  def test_drops_comments_layout_and_the_hash_bang_line
    assert_same "const x = 1; // one\n/* two */\n", "const x=1"
    assert_same "#!/usr/bin/env node\nconst x = 1;", "const x = 1;"
  end

  def test_strings_are_their_values
    assert_same "const x = 'a b'", 'const x = "a b"'
    assert_same "const x = 'it\\'s'", 'const x = "it\'s"'
    assert_same 'const x = "\\x41\\u0041\\u{41}"', 'const x = "AAA"'
    assert_same 'const x = "a\\tb"', "const x = \"a\tb\""
    assert_same "const x = 'a\\\nb'", "const x = 'ab'"
    refute_same 'const x = "a b"', 'const x = "ab"'
    refute_same 'const x = "\\q"', 'const x = "\\\\q"'
    refute_same 'const x = "\\uD83D"', 'const x = "\\\\uD83D"'
  end

  def test_templates_keep_their_substitutions
    assert_same "const f = `a ${n}\\n`", "const f = `a ${n}\n`"
    refute_same "const f = `a ${n}`", "const f = `a${n}`"
    refute_same "const f = `${n}`", "const f = `${n}${n}`"
  end

  def test_numbers_are_their_values
    assert_same "const x = 1_000 + 0x1F + 0b11 + 0o17", "const x = 1000 + 31 + 3 + 15"
    assert_same "const x = 1.50 + .5 + 1e3", "const x = 1.5 + 0.5 + 1000"
    refute_same "const x = 1n", "const x = 1"
    refute_same "const x = 1.5", "const x = 1.6"
  end

  def test_a_lone_arrow_parameter_needs_no_brackets
    assert_same "const f = (x) => x", "const f = x => x"
    refute_same "const f = (x, y) => x", "const f = x => x"
    refute_same "const f = ({ x }) => x", "const f = x => x"
  end

  def test_keeps_the_empty_parts_of_a_for
    refute_same "for (;; i++) {}", "for (i++;;) {}"
    refute_same "for (; i++;) {}", "for (i++;;) {}"
  end

  # ESTree keeps the brackets that only group as a flag on the node, and the
  # tree's shape still shows the grouping. ESTree has no node for a property
  # set on `this`, which this stage marks for representation.rb.
  def test_where_this_stage_differs_from_the_parser
    assert_same "const y = (a * b) + c", "const y = a * b + c"
    refute_same "const y = a * (b + c)", "const y = a * b + c"
    assert_includes ast("this.count = 0"), "(this_property this count)"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
