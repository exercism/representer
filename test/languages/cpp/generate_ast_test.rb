require_relative "stage_helper"

# Tests C++'s GenerateAST stage. Each assert_same pair is code that a C++
# compiler reads the same way, ignoring comments and spacing, and each
# refute_same pair is code that it reads differently. The last test lists the
# pairs where this stage deliberately differs from the compiler.
class CppGenerateASTTest < Minitest::Test
  include CppStages

  def test_drops_comments_and_layout
    assert_same "// a\nint x = 1; /* b */\n", "int x=1;"
  end

  def test_numbers_are_their_values
    assert_same "int x = 1'000 + 0x1F + 017;", "int x = 1000 + 31 + 15;"
    assert_same "double x = 1.50;", "double x = 1.5;"
    refute_same "auto x = 0xFFFFFFFF;", "auto x = 4294967295;"
    refute_same "auto x = 1.0f;", "auto x = 1.0;"
    refute_same "auto x = 10u;", "auto x = 10;"
  end

  def test_strings_are_their_values
    assert_same 'const char* s = "ab";', 'const char* s = "a" "b";'
    assert_same 'const char* s = "a\\\\nb";', 'const char* s = R"(a\\nb)";'
    assert_same 'const char* s = "a\\x41";', 'const char* s = "aA";'
    refute_same 'const char* s = "a";', 'const char* s = "b";'
    refute_same 'const char* s = "a";', 'const char* s = L"a";'
  end

  def test_words_for_operators_are_the_operators
    code = "int f(int a, int b) { %s }"
    assert_same format(code, "return a and b;"), format(code, "return a && b;")
    assert_same format(code, "return not a;"), format(code, "return !a;")
    assert_same format(code, "return a or b;"), format(code, "return a || b;")
    assert_same format(code, "a xor_eq b; return a;"), format(code, "a ^= b; return a;")
    refute_same format(code, "return a and b;"), format(code, "return a or b;")
  end

  def test_template_parameters_with_class_or_typename_are_the_same
    assert_same "template <class T> T f(T a) { return a; }", "template <typename T> T f(T a) { return a; }"
  end

  def test_the_statement_after_an_else_belongs_to_the_if
    code = "int f(int a) { if (a) { return 1; } else %s }"
    refute_same format(code, "{ return 2; }"), format(code, "return 2;")
    refute_same format(code, "{ return 2; }"), "int f(int a) { if (a) { return 1; } { return 2; } }"
  end

  def test_each_name_of_a_declaration_keeps_its_own_value
    refute_same "int a = 1, b;", "int a, b = 1;"
    refute_same "struct A { int a = 1, b; };", "struct A { int a, b = 1; };"
    refute_same "int a, b;", "int a; int b;"
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "void f(int* p) { delete[] p; }", "void f(int* p) { delete p; }"
    refute_same "void f(int* p) { ::delete p; }", "void f(int* p) { delete p; }"
    refute_same "int* f() { return ::new int; }", "int* f() { return new int; }"
    refute_same "enum class E { A };", "enum E { A };"
    refute_same "enum struct E { A };", "enum E { A };"
    refute_same "class A { public: int x; };", "class A { private: int x; };"
    refute_same "class A { protected: int x; };", "class A { private: int x; };"
    refute_same "class B : public A {};", "class B : private A {};"
    refute_same "struct S { using enum E; };", "struct S { using E; };"
    refute_same "class A { friend class B; };", "class A { friend struct B; };"
    refute_same "int f(int a) { for (;; a++) {} return a; }", "int f(int a) { for (a++;;) {} return a; }"
    refute_same "struct A { int operator()(int x); };", "struct A { int operator[](int x); };"
    refute_same "struct A { void* operator new(size_t n); };", "struct A { void* operator delete(size_t n); };"
  end

  # The compiler reads an escape that it doesn't know, such as `\q`, as the
  # letter after it, and this stage keeps the escape, so two different
  # strings can never get the same value. An integer too large for an int
  # keeps its text, digit separators and all.
  def test_where_this_stage_differs_from_the_compiler
    refute_same 'const char* s = "a\\qb";', 'const char* s = "aqb";'
    refute_same "long x = 10'000'000'000;", "long x = 10000000000;"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
