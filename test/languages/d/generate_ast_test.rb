require_relative "stage_helper"

# Tests D's GenerateAST stage. Each assert_same pair is code that D's parser
# reads the same way, ignoring spacing, and each refute_same pair is code
# that it reads differently.
class DGenerateASTTest < Minitest::Test
  include DStages

  def test_drops_layout
    assert_same "int f(int a, int b) { return a + b; }", "int f(int a,int b)\n{\n    return a+b;\n}\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_function("return (a % 4 == 0) && b;"), in_function("return a % 4 == 0 && b;")
    assert_same in_function("if ((a)) b++;"), in_function("if (a) b++;")
    refute_same in_function("return (a + b) * 2;"), in_function("return a + b * 2;")
  end

  def test_a_module_declaration_holds_the_rest_of_the_file
    assert_equal "(source_file\n  (module_declaration\n    (module_fqn leap))\n  (function_declaration\n    " \
                 "(type void) f\n    (parameters)\n    (function_body\n      (block_statement))))",
                 ast("module leap;\nvoid f() {}")
  end

  def test_numbers_are_their_values
    assert_same in_function("a = 1_000 + 0x1F + 0b11;"), in_function("a = 1000 + 31 + 3;")
    assert_same in_function("a = 1.50 + 1.5e3;"), in_function("a = 1.5 + 1500.0;")
    refute_same in_function("a = 0xFFFFFFFF;"), in_function("a = 4294967295;")
    refute_same in_function("a = 1L;"), in_function("a = 1;")
    refute_same in_function("a = 1.0f;"), in_function("a = 1.0;")
  end

  def test_strings_are_their_values
    assert_same in_function('a = `x\y` ~ r"z" ~ q{a < b};'), in_function('a = "x\\\\y" ~ "z" ~ "a < b";')
    assert_same in_function('a = "A\x41\t";'), in_function("a = \"AA\t\";")
    refute_same in_function('a = "\xE9";'), in_function('a = "é";')
    refute_same in_function('a = "a"d;'), in_function('a = "a";')
    refute_same in_function('a = x"0A";'), in_function('a = x"0B";')
    refute_same in_function('a = i"a$(b)";'), in_function('a = i"c$(b)";')
  end

  def test_a_body_after_an_arrow_is_a_return
    assert_same "int f(int a) => a * 2;", "int f(int a) { return a * 2; }"
    assert_same in_function("auto g = x => x * 2;"), in_function("auto g = (x) { return x * 2; };")
    assert_same in_function("auto g = (int x) => x;"), in_function("auto g = (int x) { return x; };")
    refute_same in_function("auto g = (int x) => x;"), in_function("auto g = (x) => x;")
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same in_function("foreach (x; xs) a++;"), in_function("foreach_reverse (x; xs) a++;")
    refute_same in_function("static if (a) {}"), in_function("if (a) {}")
    refute_same in_function("final switch (a) { case 1: break; }"), in_function("switch (a) { case 1: break; }")
    refute_same in_function("for (;; a++) {}"), in_function("for (a++;;) {}")
    refute_same in_function("const(char)[] s;"), in_function("const char[] s;")
    refute_same in_function("int[] s;"), in_function("int s;")
    refute_same in_function("static int s;"), in_function("int s;")
    refute_same in_function("auto g = function int(int x) => x;"), in_function("auto g = delegate int(int x) => x;")
    refute_same "void f(T : int)() {}", "void f(T = int)() {}"
    refute_same in_function("a = !b;"), in_function("a = -b;")
  end

  def test_a_single_template_argument_is_a_list_of_one
    assert_same in_function("a = b.to!int;"), in_function("a = b.to!(int);")
    assert_same in_function('a = xs.map!"a * 2";'), in_function('a = xs.map!("a * 2");')
    assert_same in_function("a = b.to!T;"), in_function("a = b.to!(T);")
    refute_same in_function("a = b.to!(int, T);"), in_function("a = b.to!int;")
  end

  # D's parser gives each of these pairs a different tree, although they
  # run the same, so they stay apart.
  def test_keeps_the_spellings_that_the_parser_reads_differently
    refute_same in_function("if (a) b++;"), in_function("if (a) { b++; }")
    refute_same in_function("a = xs.length();"), in_function("a = xs.length;")
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
