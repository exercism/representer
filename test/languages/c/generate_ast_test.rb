require_relative "stage_helper"

# Tests C's GenerateAST stage. Each assert_same pair is code that a C
# compiler reads the same way, ignoring comments and spacing, and each
# refute_same pair is code that it reads differently. The last test lists the
# pairs where this stage deliberately differs from the compiler.
class CGenerateASTTest < Minitest::Test
  include CStages

  def test_drops_comments_and_layout
    assert_same "// a\nint x = 1; /* b */\n", "int x=1;"
  end

  def test_numbers_are_their_values
    assert_same "int x = 1000 + 0x1F + 017;", "int x = 1000 + 31 + 15;"
    assert_same "double x = 1.50;", "double x = 1.5;"
    refute_same "long x = 0xFFFFFFFF;", "long x = 4294967295;"
    refute_same "float x = 1.0f;", "float x = 1.0;"
    refute_same "unsigned x = 10u;", "unsigned x = 10;"
  end

  def test_strings_are_their_values
    assert_same 'const char *s = "ab";', 'const char *s = "a" "b";'
    assert_same 'const char *s = "a\\x41\\n";', 'const char *s = "aA\\012";'
    refute_same 'const char *s = "a";', 'const char *s = "b";'
    refute_same 'const char *s = "a";', 'const wchar_t *s = L"a";'
  end

  def test_brackets_that_only_group_go
    code = "int f(int a, int b) { %s }"
    assert_same format(code, "return (a % 4 == 0) && (b);"), format(code, "return a % 4 == 0 && b;")
    assert_same format(code, "while ((a = b)) a--; return sizeof (a);"), format(code, "while (a = b) a--; return sizeof a;")
    refute_same format(code, "return (a + b) * 2;"), format(code, "return a + b * 2;")
    refute_same format(code, "return f((a, b), 1);"), format(code, "return f(a, b, 1);")
  end

  def test_the_statement_after_an_else_belongs_to_the_if
    code = "int f(int a) { if (a) { return 1; } else %s }"
    refute_same format(code, "{ return 2; }"), format(code, "return 2;")
    refute_same format(code, "{ return 2; }"), "int f(int a) { if (a) { return 1; } { return 2; } }"
  end

  def test_each_name_of_a_declaration_keeps_its_own_value
    refute_same "int a = 1, b;", "int a, b = 1;"
    refute_same "int a, b;", "int a; int b;"
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "int f(int a) { for (;; a++) {} return a; }", "int f(int a) { for (a++;;) {} return a; }"
    refute_same "struct A { int x; };", "union A { int x; };"
    refute_same "#ifdef A\nint x;\n#endif\n", "#ifndef A\nint x;\n#endif\n"
    refute_same "int f(int *p) { return p->x; }", "int f(int *p) { return p.x; }"
    refute_same "int f();", "int f(void);"
  end

  # The compiler reads an escape that it doesn't know, such as `\q`, as the
  # letter after it, and this stage keeps the escape, so two different
  # strings can never get the same value. An integer too large for an int
  # keeps its text.
  def test_where_this_stage_differs_from_the_compiler
    refute_same 'const char *s = "a\\qb";', 'const char *s = "aqb";'
    refute_same "long x = 10000000000;", "long x = 0x2540BE400;"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
