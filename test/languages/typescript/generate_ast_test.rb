require_relative "stage_helper"

# Tests TypeScript's GenerateAST stage. Each assert_same pair gets the same
# tree from TypeScript's parser (typescript-estree, comparing each literal's
# value and ignoring locations and comments), and each refute_same pair gets
# different trees.
class TypeScriptGenerateASTTest < Minitest::Test
  include TypeScriptStages

  def test_drops_comments_layout_and_the_hash_bang_line
    assert_same "const x = 1; // one\n/* two */\n", "const x = 1"
    assert_same "#!/usr/bin/env node\nconst x = 1;\n", "const x = 1;\n"
  end

  def test_drops_brackets_that_only_group
    assert_same "const y = (a * b) + c", "const y = a * b + c"
    refute_same "const y = (a + b) * c", "const y = a + b * c"
  end

  def test_strings_are_their_values
    assert_same "const x = 'a b'", 'const x = "a b"'
    assert_same "const x = `a b`", 'const x = "a b"'
    assert_same 'const x = "\\x41\\u0041\\u{41}"', 'const x = "AAA"'
    assert_same "const x = 'it\\'s'", 'const x = "it\'s"'
    refute_same 'const x = "a b"', 'const x = "ab"'
    refute_same 'const x = "\\uD83D"', 'const x = "\\\\uD83D"'
  end

  def test_template_strings_keep_their_substitutions
    assert_same "const x = `a${b}\\n`", "const x = `a${b}\n`"
    refute_same "const x = `a${b}`", "const x = `a${c}`"
  end

  def test_numbers_are_their_values
    assert_same "const x = 1_000 + 1000.0 + 1e3", "const x = 1000 + 1000 + 1000"
    assert_same "const x = 0x1F + 1.50", "const x = 31 + 1.5"
    refute_same "const x = 10n", "const x = 10"
    refute_same "const x = 1.5", "const x = 15"
  end

  def test_a_single_arrow_parameter_needs_no_brackets
    assert_same "const f = (x) => x", "const f = x => x"
    refute_same "const f = (x: number) => x", "const f = x => x"
    refute_same "const f = (x, y) => x", "const f = x => x"
  end

  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "class A { private x = 1 }", "class A { public x = 1 }"
    refute_same "class A { x = 1 }", "class A { readonly x = 1 }"
    refute_same "const x: string = ''", "const x: number = ''"
    refute_same "const x: string = ''", "const x: string[] = ''"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
