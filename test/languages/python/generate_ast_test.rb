require_relative "stage_helper"

# Tests Python's GenerateAST stage. Each assert_same pair gets the same tree
# from Python's own parser (`ast.dump`, without line numbers), and each
# refute_same pair gets different trees. The last test lists the pairs where
# this stage deliberately differs from the parser.
class PythonGenerateASTTest < Minitest::Test
  include PythonStages

  def test_drops_comments_and_layout
    assert_same "x = 1  # one\n", "x = 1"
    assert_same "x = (1 +\n     2)", "x = 1 + \\\n    2"
  end

  def test_strings_are_their_values
    assert_same "x = 'a b'", 'x = "a b"'
    assert_same "x = 'a\\nb'", "x = '''a\nb'''"
    assert_same "x = 'a\\tb'", "x = \"a\tb\""
    assert_same "x = r'a\\n'", "x = 'a\\\\n'"
    refute_same "x = 'a'", "x = b'a'"
    refute_same "x = 'a'", "x = u'a'"
    refute_same "x = 'a'", "x = f'a'"
    refute_same "x = 'a\\n'", "x = 'a\\\\n'"
  end

  def test_strings_written_next_to_each_other_are_joined
    assert_same "x = 'a' \"b\"", "x = 'ab'"
    assert_same "x = b'a' b'b'", "x = b'ab'"
    assert_same "x = f'a{y}' 'b'", "x = f'a{y}b'"
  end

  def test_f_strings_keep_their_substitutions
    assert_same "x = f'a {n}'", 'x = f"a {n}"'
    assert_same "x = f'{{a}}'", "x = f'{{' 'a}'"
    refute_same "x = f'a {n}'", "x = f'a{n}'"
    refute_same "x = f'{n!r}'", "x = f'{n}'"
    refute_same "x = f'{n:>10}'", "x = f'{n:<10}'"
  end

  def test_numbers_are_their_values
    assert_same "x = 1_000 + 0x10 + 0o17 + 0b11", "x = 1000 + 16 + 15 + 3"
    assert_same "x = 1e3 + 1.50 + .5", "x = 1000.0 + 1.5 + 0.5"
    assert_same "x = 2j + 1.5J", "x = 2.0j + 1.50j"
    refute_same "x = 1", "x = 1.0"
    refute_same "x = 1", "x = 1j"
  end

  def test_tuples_and_brackets_that_only_group
    assert_same "x = (a + b) + c", "x = a + b + c"
    refute_same "x = a * (b + c)", "x = a * b + c"
    assert_same "x = 1, 2", "x = (1, 2)"
    assert_same "a, b = x", "(a, b) = x"
    refute_same "x = (1,)", "x = 1"
  end

  def test_a_trailing_comma_that_makes_a_tuple_is_kept
    refute_same "x = a[1,]", "x = a[1]"
    refute_same "match x:\n    case 1,:\n        pass", "match x:\n    case 1:\n        pass"
    refute_same "match x,:\n    case 1:\n        pass", "match x:\n    case 1:\n        pass"
  end

  def test_a_lone_generator_argument
    assert_same "x = sum(n for n in a)", "x = sum((n for n in a))"
    refute_same "x = f((n for n in a), 1)", "x = f(n for n in a)"
  end

  def test_slices_stay_apart
    refute_same "x = a[1:]", "x = a[:1]"
  end

  def test_sequence_patterns
    assert_same "match x:\n    case [1, 2]:\n        pass", "match x:\n    case (1, 2):\n        pass"
    refute_same "[a, b] = x", "(a, b) = x"
  end

  # Python's parser has no `elif`, so it gives `elif` the same tree as an
  # `else` that holds only an `if`. A mentor would tell a student who writes
  # the second to use `elif`, so this stage keeps them apart.
  def test_where_this_stage_differs_from_the_parser
    refute_same "if a:\n    b\nelif c:\n    d", "if a:\n    b\nelse:\n    if c:\n        d"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
