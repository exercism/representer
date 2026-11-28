require "test_helper"

class JavaTest < InspectorTest
  extend UpstreamTests

  track "java"

  PER_DECLARATION = "The old representer gave each declaration its own placeholder, so a field and a parameter with " \
                    "the same name, or two parameters of different methods, got different placeholders. Inspector " \
                    " renames by name, so they share one. The equivalent file has the later placeholders " \
                    "changed to the first, and the mapping lists the name once.".freeze

  # The deviation for a test whose old mapping has the same name more than once.
  def self.per_declaration(name, **extra)
    mapping = JSON.parse(File.read(File.join(__dir__, "..", "fixtures", "java", name, "expected_mapping.json")))
    repeated = mapping.group_by { |_, original| original }.values.select { |entries| entries.size > 1 }
    return extra if repeated.empty?

    restore = repeated.flat_map { |entries| entries.drop(1).map { |placeholder, _| [placeholder, entries.first.first] } }.to_h
    why = [PER_DECLARATION, extra[:why]].compact.join(" ")
    names = repeated.map { |entries| entries.first.last }
    { restore: restore.merge(extra.fetch(:restore, {})), remove: names + extra.fetch(:remove, []), add: names, why: }
  end

  DEVIATIONS = {
    "scenario-simple" => {
      parse_error: true,
      why: "The upstream scenario has a syntax error (a missing semicolon after the return), which the old " \
           "representer's Java compiler repaired. Inspector gives it Basic's representation."
    },
    "scenario-lambda-arguments" => {
      replace: { ".filter(" => ".PLACEHOLDER_02(" },
      why: "The solution defines a method called filter, so Inspector renames every use of the name, " \
           "including the call to Stream.filter. The old representer renamed only the declaration."
    },
    "scenario-class-with-nested-enum" => per_declaration("scenario-class-with-nested-enum")
  }.freeze

  upstream_tests ".java", deviations: DEVIATIONS

  # Two of the old tests have several solution files, which upstream_tests
  # can't take, so they are written out here. Each has its input files, the
  # old representation split into one equivalent file for each input file, and
  # the old mapping. As above, a name that the old mapping lists more than once
  # is one placeholder in the equivalent files and one entry in the mapping.
  Dir[File.join(__dir__, "..", "fixtures", "java-multi-file", "*")].sort.each do |dir|
    define_method("test_upstream_#{File.basename(dir)}") do
      mapping = JSON.parse(File.read(File.join(dir, "expected_mapping.json")))
      inputs = Dir[File.join(dir, "*.java")].to_h { |path| [File.basename(path), File.read(path)] }
      equivalents = Dir[File.join(dir, "equivalent", "*.java")].to_h do |path|
        [File.basename(path), restore_repeated(File.read(path), mapping)]
      end
      assert_equal inputs.keys.sort, equivalents.keys.sort

      actual = Inspector::RepresentSolution.("java", inputs)
      assert_equal Inspector::RepresentSolution.("java", equivalents).representation, actual.representation
      assert_equal mapping.values.uniq.sort, actual.mapping.values.uniq.sort
    end
  end

  def test_comments_imports_and_package_go
    assert_same_representation "class A { int f() { return 1; } }",
      "package a.b;\nimport java.util.List;\n/** Docs. */\nclass A {\n    // note\n    int f() { return 1; /* done */ }\n}"
  end

  def test_if_else_and_loops_get_braces
    assert_same_representation "class A { void f(int a) { if (a > 1) g(); else h(); } }",
      "class A { void f(int b) { if (b > 1) { g(); } else { h(); } } }"
    assert_same_representation "class A { void f(int a) { if (a > 1) { g(); } else { if (a < 0) { h(); } } } }",
      "class A { void f(int a) { if (a > 1) { g(); } else if (a < 0) { h(); } } }"
    refute_same_representation "class A { void f(int a) { if (a > 1) g(); } }", "class A { void f(int a) { while (a > 1) g(); } }"
  end

  def test_fully_qualified_names
    assert_same_representation "class A { java.util.List<String> f() { return java.util.Arrays.asList(); } }",
      "import java.util.*;\nclass A { List<String> f() { return Arrays.asList(); } }"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation "class A { long f() { return 1_000L + 0x10; } }", "class A { long f() { return 1000L + 16; } }"
    assert_same_representation "class A { String f() { return \"a\\u0041\\n\"; } }", "class A { String f() { return \"aA\\n\"; } }"
    refute_same_representation "class A { long f() { return 1L; } }", "class A { long f() { return 1; } }"
  end

  def test_methods_named_after_library_methods_are_renamed
    assert_same_representation "class A { int max() { return 1; } }", "class A { int min() { return 1; } }"
    refute_same_representation "class A { int f(java.util.List<Integer> a) { return a.size(); } }",
      "class A { int f(java.util.List<Integer> a) { return a.indexOf(1); } }"
  end

  def test_members_are_renamed_by_name
    assert_same_representation "class A { private int total; int deposit(int n) { return this.total + n; } }",
      "class B { private int balance; int credit(int m) { return this.balance + m; } }"
    refute_same_representation "class A { int f(A other) { return other.x; } int x; }",
      "class A { int f(A other) { return other.y; } int x; }"
  end

  def test_method_references_and_records
    assert_same_representation "class A { void f() { g(this::h); } void h() {} }", "class B { void i() { g(this::j); } void j() {} }"
    assert_same_representation "record P(int x) { int twice() { return x * 2; } }",
      "record Q(int y) { int double2() { return y * 2; } }"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_java_version
    assert_basic_representation "class A { int f( }"
  end

  # These brackets and semicolons are the only difference between each pair.
  def test_tokens_that_tell_programs_apart_are_kept
    refute_same_representation "class A { int[] a; }", "class A { int[][] a; }"
    refute_same_representation "class A { void f(int[] a) {} }", "class A { void f(int[][] a) {} }"
    refute_same_representation "class A { void f(int i) { for (;; i++) {} } }", "class A { void f(int i) { for (i++;;) {} } }"
  end

  # The engine renames by name, so two methods that reuse a parameter's name
  # share its placeholder.
  def test_a_name_reused_in_two_methods_gets_one_placeholder
    shared = "class L {\n  int a(int x) { return x; }\n  int b(int x) { return x; }\n}"
    distinct = "class L {\n  int a(int x) { return x; }\n  int b(int y) { return y; }\n}"
    refute_same_representation shared, distinct
    refute_same_representation "class L {\n  int a(int x, int y) { return x - y; }\n}",
      "class L {\n  int a(int x, int y) { return y - x; }\n}"
  end

  def test_a_field_and_a_parameter_with_the_same_name_stay_apart
    code = "class L {\n  int total;\n  L(int total) { this.total = %s; }\n}"
    refute_same_representation format(code, "total"), format(code, "this.total")
  end

  def restore_repeated(code, mapping)
    mapping.group_by { |_, original| original }.values.reduce(code) do |result, entries|
      entries.drop(1).reduce(result) { |text, (placeholder, _)| text.gsub(/\b#{placeholder}\b/, entries.first.first) }
    end
  end
end
