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

  def test_comments_includes_and_using_declarations_go
    assert_same_representation "int f() { return 1; }",
      "#pragma once\n#include <vector>\nusing namespace std;\n// note\nint f() { return 1; /* done */ }\n"
  end

  def test_an_include_guard_is_the_same_as_pragma_once
    assert_same_representation "#pragma once\nint x;", "#ifndef X_H\n#define X_H\nint x;\n#endif\n"
    refute_same_representation "#pragma once\nint x;", "#ifndef X_H\n#define Y_H\nint x;\n#endif\n"
  end

  def test_if_else_and_loops_get_braces
    assert_same_representation "int f(int a) { if (a > 1) return 1; else if (a < 0) return 2; return 3; }",
      "int f(int b) { if (b > 1) { return 1; } else { if (b < 0) { return 2; } } return 3; }"
    refute_same_representation "int f(int a) { if (a > 1) return 1; return 3; }", "int f(int a) { while (a > 1) return 1; return 3; }"
  end

  def test_numbers_strings_and_operator_words
    assert_same_representation "bool f(int a) { return a == 1'000 and \"a\" \"b\" != nullptr; }",
      "bool f(int b) { return b == 1000 && \"ab\" != nullptr; }"
    refute_same_representation "auto x = 10u;", "auto x = 10;"
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

  def test_a_function_named_like_a_library_function_is_renamed
    code = "int %s(int a) { return a; }"
    assert_same_representation format(code, "count"), format(code, "size")
    assert_same_representation format(code, "total"), format(code, "amount")
  end

  def test_the_exercise_files_make_no_difference
    tests = { "leap_test.cpp" => "#include \"leap.h\"\nint main() { return leap::is_leap_year(2000); }\n" }
    result = represent("namespace leap { bool is_leap_year(int year) { return true; } }", filename: "leap.cpp",
      exercise_files: tests)
    assert_equal %w[leap is_leap_year year], result.mapping.values
  end

  def test_syntax_errors_are_unrepresentable_with_the_cpp_version
    result = represent("int f( {")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::Cpp::Representation.version, result.version
  end
end
