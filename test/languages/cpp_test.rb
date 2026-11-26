require "test_helper"

class CppTest < RepresenterTest
  extend UpstreamTests

  track "cpp"

  # Not ported: the upstream tests multiple-files-missing,
  # multiple-files-partially-missing and single-file-missing. They check how
  # the old representer's command line failed when a file named in its config
  # didn't exist. The service gets the files in the request, so it has no such
  # case.

  DEVIATIONS = {
    "syntax-error" => {
      unrepresentable: true,
      why: "The solution has a syntax error, so it gets no representation. The old representer worked on tokens, so it " \
           "represented any text."
    }
  }.freeze

  upstream_tests ".h", deviations: DEVIATIONS

  # The old test with two solution files, which upstream_tests can't take. It
  # has its input files, the old representation split into one equivalent file
  # for each input file, and the old mapping.
  Dir[File.join(__dir__, "..", "fixtures", "cpp-multi-file", "*")].sort.each do |dir|
    define_method("test_upstream_#{File.basename(dir)}") do
      mapping = JSON.parse(File.read(File.join(dir, "expected_mapping.json")))
      inputs = Dir[File.join(dir, "*.{cpp,h}")].to_h { |path| [File.basename(path), File.read(path)] }
      equivalents = Dir[File.join(dir, "equivalent", "*.{cpp,h}")].to_h { |path| [File.basename(path), File.read(path)] }
      assert_equal inputs.keys.sort, equivalents.keys.sort

      actual = Representer::RepresentSolution.("cpp", inputs, {})
      assert_equal Representer::RepresentSolution.("cpp", equivalents, {}).representation, actual.representation
      assert_equal mapping.values.sort, actual.mapping.values.sort
    end
  end

  def wrap(body) = "int f(int a, int b) {\n#{body}\n}\n"

  def test_comments_are_dropped
    assert_same_representation "int x;", "// a\nint x; /* b */\n"
  end

  def test_pragmas_includes_and_using_declarations_are_dropped
    assert_same_representation "int x;", "#pragma once\n#include \"x.h\"\nint x;"
    assert_same_representation "int x;", "#include <vector>\n#include <map>\nint x;"
    assert_same_representation "int x;", "using namespace std;\nusing std::string;\nint x;"
    assert_same_representation "int f() { return 1; }", "int f() { using namespace std; return 1; }"
    refute_same_representation "struct B : A { using A::A; };", "struct B : A { };"
    refute_same_representation "#define N 1\nint x = N;", "int x = N;"
    refute_same_representation "#include <cmath>\ndouble f(double x) { return std::sqrt(x); }",
      "#include <cmath>\ndouble f(double x) { return std::cbrt(x); }"
  end

  def test_numbers_are_their_values
    assert_same_representation "int x = 1'000 + 0x1F + 017;", "int x = 1000 + 31 + 15;"
    assert_same_representation "double x = 1.50;", "double x = 1.5;"
    refute_same_representation "auto x = 0xFFFFFFFF;", "auto x = 4294967295;"
    refute_same_representation "auto x = 1.0f;", "auto x = 1.0;"
    refute_same_representation "auto x = 10u;", "auto x = 10;"
  end

  def test_an_include_guard_is_the_same_as_pragma_once
    assert_same_representation "#pragma once\nint x;", "#ifndef X_H\n#define X_H\nint x;\n#endif\n"
    refute_same_representation "#pragma once\nint x;", "#ifndef X_H\n#define Y_H\nint x;\n#endif\n"
  end

  def test_braces_are_added_to_controlled_statements
    assert_same_representation wrap("if (a) return b; else return a;"), wrap("if (a) { return b; } else { return a; }")
    assert_same_representation wrap("while (a) a--;"), wrap("while (a) { a--; }")
    assert_same_representation wrap("for (int i = 0; i < a; ++i) b++;"), wrap("for (int i = 0; i < a; ++i) { b++; }")
    refute_same_representation wrap("if (a) return b;"), wrap("while (a) return b;")
  end

  def test_else_with_only_an_if_is_else_if
    assert_same_representation wrap("if (a) { b++; } else if (b) { a++; }"),
      wrap("if (a) { b++; } else { if (b) { a++; } }")
    refute_same_representation wrap("if (a) { b++; } else if (b) { a++; }"),
      wrap("if (a) { b++; } else { a--; if (b) { a++; } }")
  end

  def test_words_for_operators_are_the_operators
    assert_same_representation wrap("return a and b;"), wrap("return a && b;")
    assert_same_representation wrap("return not a;"), wrap("return !a;")
    assert_same_representation wrap("return a or b;"), wrap("return a || b;")
    refute_same_representation wrap("return a and b;"), wrap("return a or b;")
  end

  def test_template_parameters_with_class_or_typename_are_the_same
    assert_same_representation "template <class T> T f(T a) { return a; }", "template <typename T> T f(T a) { return a; }"
  end

  def test_strings_are_their_values
    assert_same_representation 'const char* s = "ab";', 'const char* s = "a" "b";'
    assert_same_representation 'const char* s = "a\\\\nb";', 'const char* s = R"(a\\nb)";'
    assert_same_representation 'const char* s = "a\\x41";', 'const char* s = "aA";'
    refute_same_representation 'const char* s = "a";', 'const char* s = "b";'
    refute_same_representation 'const char* s = "a";', 'const char* s = L"a";'
    refute_same_representation 'const char* s = "a\\qb";', 'const char* s = "aqb";'
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation "int f(int a, char** b) { int c = a; int d[2], e; return c; }",
      "int f(int x, char** y) { int z = x; int u[2], v; return z; }"
    refute_same_representation wrap("return a;"), wrap("return b;")
  end

  def test_pointer_and_reference_declarators_are_renamed
    assert_same_representation "void f(int* a, int& b, const int& c) { *a = b + c; }",
      "void f(int* x, int& y, const int& z) { *x = y + z; }"
  end

  def test_types_fields_and_methods_are_renamed_through_dots_and_scopes
    code = "class %s {\n public:\n  int %s;\n  int %s() const { return %s; }\n};\nint g(%s o) { return o.%s + o.%s(); }"
    assert_same_representation format(code, "A", "p", "q", "p", "A", "p", "q"), format(code, "B", "r", "s", "r", "B", "r", "s")
  end

  def test_namespaces_and_qualified_names_are_renamed
    code = "namespace %s { int %s(int n) { return n; } }\nint g() { return %s::%s(1); }"
    assert_same_representation format(code, "a", "f", "a", "f"), format(code, "b", "h", "b", "h")
  end

  def test_names_in_the_standard_library_keep_their_names
    refute_same_representation "int f(std::vector<int> v) { return std::count(v.begin(), v.end(), 1); }",
      "int f(std::vector<int> v) { return std::max(v.begin(), v.end(), 1); }"
    refute_same_representation "int f(std::vector<int> v) { return v.size(); }", "int f(std::vector<int> v) { return v.max_size(); }"
  end

  def test_a_function_named_like_a_library_function_keeps_its_name
    code = "int %s(int a) { return a; }"
    refute_same_representation format(code, "count"), format(code, "size")
    assert_same_representation format(code, "total"), format(code, "amount")
  end

  def test_enumerators_and_enum_names_are_renamed
    code = "enum class %s { %s, Other };\nint f() { return static_cast<int>(%s::%s); }"
    assert_same_representation format(code, "A", "X", "A", "X"), format(code, "B", "Y", "B", "Y")
  end

  def test_names_the_tests_use_are_kept
    refute_same_representation "int f() { return 1; }", "int g() { return 1; }",
      exercise_files: { "t_test.cpp" => "#include \"t.h\"\nint main() { return f(); }\n" }
  end

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "int f( {"
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_tokens_that_tell_programs_apart_are_kept
    refute_same_representation "void f(int* p) { delete[] p; }", "void f(int* p) { delete p; }"
    refute_same_representation "void f(int* p) { ::delete p; }", "void f(int* p) { delete p; }"
    refute_same_representation "int* f() { return ::new int; }", "int* f() { return new int; }"
    refute_same_representation "enum class E { A };", "enum E { A };"
    refute_same_representation "enum struct E { A };", "enum E { A };"
    refute_same_representation "class A { public: int x; };", "class A { private: int x; };"
    refute_same_representation "class A { protected: int x; };", "class A { private: int x; };"
    refute_same_representation "class B : public A {};", "class B : private A {};"
    refute_same_representation "struct S { using enum E; };", "struct S { using E; };"
    refute_same_representation "class A { friend class B; };", "class A { friend struct B; };"
    refute_same_representation wrap("for (;; a++) {} return a;"), wrap("for (a++;;) {} return a;")
    refute_same_representation "struct A { int operator()(int x); };", "struct A { int operator[](int x); };"
    refute_same_representation "struct A { void* operator new(size_t n); };", "struct A { void* operator delete(size_t n); };"
  end
end
