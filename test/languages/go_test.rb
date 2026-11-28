require "test_helper"

class GoTest < InspectorTest
  extend UpstreamTests

  track "go"

  DEVIATIONS = {
    "raindrops-7" => {
      why: "The old representer didn't rename the type of a struct field (`sound sound`), so its output is only " \
           "valid code if that type keeps its name. Inspector renames it, so the equivalent has the " \
           "placeholder there."
    }
  }.freeze

  upstream_tests ".go", deviations: DEVIATIONS

  def wrap(body) = "package p\n\nfunc F() {\n#{body}\n}\n"

  ### Imports ###

  def test_imports_are_dropped_unless_they_run_code
    assert_same_representation "package p\n\nimport \"a\"\n", "package p\n"
    assert_same_representation "package p\n\nimport (\n\t\"b\"\n\tc \"a\"\n)\n", "package p\n"
    assert_same_representation "package p\n\nimport . \"a\"\n", "package p\n"
    refute_same_representation "package p\n\nimport _ \"embed\"\n", "package p\n"
    refute_same_representation "package p\n\nimport \"strings\"\n\nfunc F(s string) string { return strings.ToUpper(s) }\n",
      "package p\n\nimport \"strings\"\n\nfunc F(s string) string { return strings.ToLower(s) }\n"
  end

  ### Files ###

  def test_splitting_code_across_files_changes_nothing
    one = "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(B()) }\n\nfunc B() int { return 1 }\n"
    two = {
      "a.go" => "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(B()) }\n",
      "b.go" => "package p\n\nfunc B() int { return 1 }\n"
    }
    swapped = { "x.go" => two["b.go"], "y.go" => two["a.go"] }
    expected = Inspector::RepresentSolution.("go", { "p.go" => one }).representation
    assert_equal expected, Inspector::RepresentSolution.("go", two).representation
    assert_equal expected, Inspector::RepresentSolution.("go", swapped).representation
  end

  def test_files_that_both_import_a_package_import_it_once
    files = { "a.go" => "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(1) }\n",
              "b.go" => "package p\n\nimport \"fmt\"\n\nfunc B() { fmt.Println(2) }\n" }
    one = "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(1) }\n\nfunc B() { fmt.Println(2) }\n"
    assert_equal represent(one).representation, Inspector::RepresentSolution.("go", files).representation
  end

  def test_different_files_with_different_code_stay_apart
    a = { "a.go" => "package p\n\nfunc A() int { return 1 }\n", "b.go" => "package p\n\nfunc B() int { return 2 }\n" }
    b = { "a.go" => "package p\n\nfunc A() int { return 1 }\n", "b.go" => "package p\n\nfunc B() int { return 3 }\n" }
    refute_equal Inspector::RepresentSolution.("go", a).representation,
      Inspector::RepresentSolution.("go", b).representation
  end

  ### Names ###

  def test_local_names_are_renamed
    assert_same_representation wrap("a := 1\n_ = a"), wrap("b := 1\n_ = b")
  end

  def test_struct_fields_and_methods_are_renamed_after_a_dot
    code = "package p\n\ntype T struct{ %s int }\n\nfunc (t T) %s() int { return t.%s }\n"
    assert_same_representation format(code, "a", "A", "a"), format(code, "b", "B", "b")
  end

  def test_other_packages_names_are_kept
    assert_same_representation "package p\n\nimport \"fmt\"\n\nfunc F() { fmt.Println(1) }\n",
      "package p\n\nimport \"fmt\"\n\nfunc G() { fmt.Println(1) }\n"
    refute_same_representation "package p\n\nimport \"fmt\"\n\nfunc F() { fmt.Println(1) }\n",
      "package p\n\nimport \"fmt\"\n\nfunc F() { fmt.Print(1) }\n"
  end

  def test_methods_with_library_names_are_renamed
    code = "package p\n\ntype T int\n\nfunc (t T) %s() string { return \"\" }\n"
    assert_same_representation format(code, "String"), format(code, "Name")
  end

  ### Validity ###

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "package p\n\nfunc F( {\n"
  end

  def test_a_string_holding_a_semicolon
    refute_same_representation "package p\n\nvar S = \";\"\n", "package p\n\nvar S = \":\"\n"
  end
end
