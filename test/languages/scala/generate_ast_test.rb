require_relative "stage_helper"

# Tests Scala's GenerateAST stage. Each assert_same pair is code that Scala's
# parser reads the same way, ignoring comments and spacing, and each
# refute_same pair is code that it reads differently. The last test lists the
# pairs where this stage deliberately differs from the parser.
class ScalaGenerateASTTest < Minitest::Test
  include ScalaStages

  def test_drops_comments_and_layout
    assert_same "// a\nobject A { val x = f(1, 2); /* b */ }\n", "object A {\n  val x = f(1, 2)\n}"
  end

  def test_braces_and_indentation_are_the_same
    assert_same "object A {\n  def f(x: Int) = x\n}", "object A:\n  def f(x: Int) = x\n"
    assert_same in_method("a match {\n  case 1 => b\n}"), in_method("a match\n  case 1 => b")
    assert_same in_method("if (a > b) a else b"), in_method("if a > b then a else b")
    assert_same in_method("for (x <- xs) yield x"), in_method("for x <- xs yield x")
    assert_same in_method("for { x <- xs } yield x"), in_method("for x <- xs yield x")
    assert_same in_method("while (a > b) f()"), in_method("while a > b do f()")
  end

  def test_an_indented_block_of_one_expression_is_that_expression
    assert_same "object A {\n  def f(x: Int) =\n    x + 1\n}", "object A {\n  def f(x: Int) = x + 1\n}"
    assert_same "object A:\n  def f(x: Int) =\n    val y = x\n    y\n", "object A {\n  def f(x: Int) = {\n    val y = x\n    y\n  }\n}"
    refute_same "object A {\n  def f(x: Int) = { x + 1 }\n}", "object A {\n  def f(x: Int) = x + 1\n}"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_method("(a + b)"), in_method("a + b")
    refute_same in_method("(a + b) * 2"), in_method("a + b * 2")
    refute_same in_method("(a, b)"), in_method("a")
  end

  def test_numbers_are_their_values
    assert_same "object A { val x = 1_000 + 0x1F }", "object A { val x = 1000 + 31 }"
    assert_same "object A { val x = 1.50 + 1e3 }", "object A { val x = 1.5 + 1000.0 }"
    assert_same "object A { val x = 1_000L + 0x10l }", "object A { val x = 1000L + 16L }"
    refute_same "object A { val x = 1L }", "object A { val x = 1 }"
    refute_same "object A { val x = 1.0f }", "object A { val x = 1.0 }"
  end

  def test_strings_are_their_values
    assert_same 'object A { val x = """a""" }', 'object A { val x = "a" }'
    assert_same 'object A { val x = "\\u0041\\t" }', "object A { val x = \"A\t\" }"
    refute_same 'object A { val x = """\\n""" }', 'object A { val x = "\\n" }'
    refute_same 'object A { val x = "a" }', "object A { val x = 'a' }"
  end

  def test_both_spellings_of_an_interpolation_are_the_same
    assert_same 'object A { val x = s"a$b!" }', 'object A { val x = s"a${b}!" }'
    assert_same 'object A { val x = raw"a\\d" }', 'object A { val x = raw"""a\\d""" }'
    refute_same 'object A { val x = s"a$b.c" }', 'object A { val x = s"a${b.c}" }'
    refute_same 'object A { val x = s"a$b" }', 'object A { val x = f"a$b" }'
    refute_same 'object A { val x = s"say \\"$b" }', 'object A { val x = s"say $b" }'
  end

  def test_backticks_around_a_name_make_no_difference
    assert_same "object A { val `x` = 1 }", "object A { val x = 1 }"
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "object A { def f() = { 1 } }", "object A { def f() { 1 } }"
    refute_same "class A(val x: Int)", "class A(x: Int)"
    refute_same "case class A(x: Int)", "class A(x: Int)"
    refute_same "trait A[+T]", "trait A[T]"
    refute_same in_method("for (x <- xs) yield x"), in_method("for (x <- xs) x")
    refute_same in_method("for (x <- xs; y = x) yield y"), in_method("for (x <- xs; y <- x) yield y")
    refute_same in_method("-a"), in_method("!a")
    refute_same "object A { def f(using x: Int) = x }", "object A { def f(x: Int) = x }"
  end

  # Scala's parser reads a block in braces with one expression as a block, and
  # this stage keeps it as one, so `{ x }` and `x` stay apart. `xs.map(f)` and
  # `xs map f` also stay apart, as they do in the parser's tree.
  def test_where_this_stage_differs_from_the_parser
    refute_same in_method("xs.map { x => x }"), in_method("xs.map(x => x)")
    refute_same in_method("xs map f"), in_method("xs.map(f)")
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
