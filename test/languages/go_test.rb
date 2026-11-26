require "test_helper"

class GoTest < RepresenterTest
  extend UpstreamTests

  track "go"

  DEVIATIONS = {
    "raindrops-7" => {
      why: "The old representer didn't rename the type of a struct field (`sound sound`), so its output is only " \
           "valid code if that type keeps its name. This representer renames it, so the equivalent has the " \
           "placeholder there."
    }
  }.freeze

  upstream_tests ".go", deviations: DEVIATIONS

  def wrap(body) = "package p\n\nfunc F() {\n#{body}\n}\n"

  ### Declarations ###

  def test_var_without_value_is_zero_value
    assert_same_representation wrap("var a int"), wrap("a := 0")
    assert_same_representation wrap("var a string"), wrap("a := \"\"")
    assert_same_representation wrap("var a bool"), wrap("a := false")
    assert_same_representation wrap("var a float64"), wrap("a := 0.0")
    assert_same_representation wrap("var a complex128"), wrap("a := 0i")
    assert_same_representation wrap("var a uint8"), wrap("a := uint8(0)")
    assert_same_representation wrap("var a byte"), wrap("a := byte(0)")
    assert_same_representation wrap("var a rune"), wrap("a := rune(0)")
  end

  def test_every_builtin_numeric_type_has_a_zero_value
    %w[int8 int16 int32 int64 uint uint8 uint16 uint32 uint64 uintptr byte rune float32 complex64].each do |type|
      assert_same_representation wrap("var a #{type}"), wrap("a := #{type}(0)")
    end
  end

  def test_var_with_value
    assert_same_representation wrap("var a int = 1"), wrap("a := 1")
    assert_same_representation wrap("var a = 1"), wrap("a := 1")
    assert_same_representation wrap("var a int64 = 1"), wrap("a := int64(1)")
    assert_same_representation wrap("var a int64 = int64(1)"), wrap("a := int64(1)")
    assert_same_representation wrap("var a rune = 'x'"), wrap("a := 'x'")
  end

  def test_var_with_a_literal_of_another_type_is_converted
    assert_same_representation wrap("var a float64 = 1"), wrap("a := float64(1)")
    refute_same_representation wrap("var a float64 = 1"), wrap("a := 1")
    refute_same_representation wrap("var a int"), wrap("a := 0.0")
  end

  def test_var_groups_and_lists_become_separate_declarations
    assert_same_representation wrap("var (\n a int\n b = 2\n)"), wrap("a := 0\nb := 2")
    assert_same_representation wrap("var a, b int"), wrap("a := 0\nb := 0")
    assert_same_representation wrap("var a, b = 1, 2"), wrap("a := 1\nb := 2")
  end

  def test_var_that_cant_be_rewritten_stays_a_var
    refute_same_representation wrap("var e error"), wrap("e := 0")
    refute_same_representation wrap("var xs []int"), wrap("xs := 0")
    refute_same_representation wrap("var t T"), wrap("t := 0")
    refute_same_representation wrap("var a, b = f()"), wrap("a := 0\nb := 0")
    refute_same_representation wrap("var _ = f()"), wrap("_ := f()")
  end

  def test_var_values_that_read_an_outer_name_stay_a_var
    refute_same_representation wrap("var a, b = 1, a"), wrap("a := 1\nb := a")
  end

  def defining(type, body) = "package p\n\ntype T #{type}\n\nfunc F() {\n#{body}\n}\n"

  def test_var_of_a_defined_type_is_its_zero_value
    assert_same_representation defining("struct{ a int }", "var t T"), defining("struct{ a int }", "t := T{}")
    assert_same_representation defining("int", "var t T"), defining("int", "t := T(0)")
    assert_same_representation defining("string", "var t T"), defining("string", "t := T(\"\")")
    assert_same_representation defining("bool", "var t T"), defining("bool", "t := T(false)")
    assert_same_representation defining("[]int", "var t T"), defining("[]int", "t := T(nil)")
    assert_same_representation defining("[3]int", "var t T"), defining("[3]int", "t := T{}")
    assert_same_representation defining("time.Duration", "var t T"), defining("time.Duration", "t := T(0)")
    assert_same_representation defining("strings.Builder", "var t T"), defining("strings.Builder", "t := T{}")
  end

  def test_var_of_a_type_defined_in_terms_of_another_follows_it
    code = "package p\n\ntype A struct{}\ntype T A\n\nfunc F() {\n%s\n}\n"
    assert_same_representation format(code, "var t T"), format(code, "t := T{}")
    code = "package p\n\ntype A int\ntype T A\n\nfunc F() {\n%s\n}\n"
    assert_same_representation format(code, "var t T"), format(code, "t := T(0)")
  end

  def test_var_of_a_defined_type_with_a_value
    assert_same_representation defining("int", "var t T = 3"), defining("int", "t := T(3)")
    assert_same_representation defining("struct{ a int }", "var t T = T{}"), defining("struct{ a int }", "t := T{}")
  end

  def test_defined_types_stay_apart
    refute_same_representation defining("struct{ a int }", "var t T"), defining("int", "var t T")
    refute_same_representation defining("int", "var t T"), defining("string", "var t T")
  end

  def test_var_of_a_generic_type_stays_a_var
    code = "package p\n\ntype T[X any] struct{ a X }\n\nfunc F() {\n%s\n}\n"
    refute_same_representation format(code, "var t T[int]"), format(code, "t := T[int]{}")
    refute_same_representation format(code, "var t T"), format(code, "t := T{}")
  end

  def test_var_of_a_standard_library_type
    assert_same_representation wrap("var sb strings.Builder"), wrap("sb := strings.Builder{}")
    assert_same_representation wrap("var mu sync.Mutex"), wrap("mu := sync.Mutex{}")
    assert_same_representation wrap("var b bytes.Buffer"), wrap("b := bytes.Buffer{}")
    assert_same_representation wrap("var d time.Duration"), wrap("d := time.Duration(0)")
    assert_same_representation wrap("var wg sync.WaitGroup"), wrap("wg := sync.WaitGroup{}")
    refute_same_representation wrap("var mu sync.Mutex"), wrap("mu := sync.RWMutex{}")
    refute_same_representation wrap("var f os.File"), wrap("f := os.File{}")
  end

  def test_package_level_var_is_not_rewritten
    refute_same_representation "package p\n\nvar a int\n", "package p\n\nvar a = 0\n"
  end

  ### Order ###

  def test_top_level_declarations_are_sorted
    assert_same_representation "package p\n\nfunc A() int { return 1 }\n\ntype T int\n\nconst C = 1\n\nvar V = 2\n",
      "package p\n\nvar V = 2\n\nconst C = 1\n\ntype T int\n\nfunc A() int { return 1 }\n"
  end

  def test_larger_declarations_of_the_same_kind_come_first
    assert_same_representation "package p\n\nfunc A() int { return 1 }\n\nfunc B() int { x := 1; return x }\n",
      "package p\n\nfunc B() int { x := 1; return x }\n\nfunc A() int { return 1 }\n"
  end

  def test_imports_are_dropped_unless_they_run_code
    assert_same_representation "package p\n\nimport \"a\"\n", "package p\n"
    assert_same_representation "package p\n\nimport (\n\t\"b\"\n\tc \"a\"\n)\n", "package p\n"
    refute_same_representation "package p\n\nimport _ \"embed\"\n", "package p\n"
    refute_same_representation "package p\n\nimport \"strings\"\n\nfunc F(s string) string { return strings.ToUpper(s) }\n",
      "package p\n\nimport \"strings\"\n\nfunc F(s string) string { return strings.ToLower(s) }\n"
  end

  def test_numbers_are_their_values
    assert_same_representation "package p\n\nconst C = 1_000 + 0x1F + 0o17\n", "package p\n\nconst C = 1000 + 31 + 15\n"
    assert_same_representation "package p\n\nconst C = 017\n", "package p\n\nconst C = 15\n"
    assert_same_representation "package p\n\nconst C = 1.50\n", "package p\n\nconst C = 1.5\n"
    refute_same_representation "package p\n\nconst C = 1.0\n", "package p\n\nconst C = 1\n"
  end

  def test_grouped_types_and_vars_are_separate_declarations
    assert_same_representation "package p\n\ntype (\n\tA int\n\tB string\n)\n", "package p\n\ntype A int\ntype B string\n"
    assert_same_representation "package p\n\nvar (\n\ta = 1\n\tb = 2\n)\n", "package p\n\nvar a = 1\nvar b = 2\n"
  end

  def test_const_groups_stay_whole
    refute_same_representation "package p\n\nconst (\n\ta = iota\n\tb\n)\n", "package p\n\nconst a = iota\nconst b\n"
  end

  ### Files ###

  def test_splitting_code_across_files_changes_nothing
    one = "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(B()) }\n\nfunc B() int { return 1 }\n"
    two = {
      "a.go" => "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(B()) }\n",
      "b.go" => "package p\n\nfunc B() int { return 1 }\n"
    }
    swapped = { "x.go" => two["b.go"], "y.go" => two["a.go"] }
    expected = Representer::RepresentSolution.("go", { "p.go" => one }, {}).representation
    assert_equal expected, Representer::RepresentSolution.("go", two, {}).representation
    assert_equal expected, Representer::RepresentSolution.("go", swapped, {}).representation
  end

  def test_files_that_both_import_a_package_import_it_once
    files = { "a.go" => "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(1) }\n",
              "b.go" => "package p\n\nimport \"fmt\"\n\nfunc B() { fmt.Println(2) }\n" }
    one = "package p\n\nimport \"fmt\"\n\nfunc A() { fmt.Println(1) }\n\nfunc B() { fmt.Println(2) }\n"
    assert_equal represent(one).representation, Representer::RepresentSolution.("go", files, {}).representation
  end

  def test_different_files_with_different_code_stay_apart
    a = { "a.go" => "package p\n\nfunc A() int { return 1 }\n", "b.go" => "package p\n\nfunc B() int { return 2 }\n" }
    b = { "a.go" => "package p\n\nfunc A() int { return 1 }\n", "b.go" => "package p\n\nfunc B() int { return 3 }\n" }
    refute_equal Representer::RepresentSolution.("go", a, {}).representation,
      Representer::RepresentSolution.("go", b, {}).representation
  end

  ### Spelling ###

  def test_strings
    assert_same_representation wrap("s := \"a\\nb\""), wrap("s := `a\nb`".sub("\\n", "\n"))
    assert_same_representation wrap('s := "\\x41\\u00e9"'), wrap('s := "Aé"')
    refute_same_representation wrap('s := "\\xff"'), wrap('s := "\\xfe"')
    refute_same_representation wrap('s := `\\n`'), wrap('s := "\\n"')
  end

  def test_parentheses_and_semicolons
    assert_same_representation wrap("x := (1 + 2)"), wrap("x := 1 + 2")
    assert_same_representation wrap("a := 1; b := 2"), wrap("a := 1\nb := 2")
  end

  def test_for_loop_semicolons_keep_their_place
    refute_same_representation wrap("for i++; ; {\n}"), wrap("for ; ; i++ {\n}")
  end

  def test_slices_keep_which_bound_is_given
    refute_same_representation wrap("_ = xs[1:]"), wrap("_ = xs[:1]")
  end

  def test_channel_directions_stay_apart
    refute_same_representation wrap("var c chan<- int"), wrap("var c <-chan int")
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

  def test_a_type_with_a_library_method_name_keeps_it
    code = "package p\n\ntype T struct{ n int }\n\nfunc (t T) %s() int { return t.n }\n"
    refute_same_representation format(code, "Len"), format(code, "Cap")
    assert_same_representation format(code, "Total"), format(code, "Sum")
  end

  def test_methods_that_go_calls_keep_their_names
    code = "package p\n\ntype T int\n\nfunc (t T) %s() string { return \"\" }\n"
    refute_same_representation format(code, "String"), format(code, "Name")
  end

  def test_names_the_tests_use_are_kept
    tests = "package p\n\nfunc TestF(t *testing.T) { F() }\n"
    refute_same_representation "package p\n\nfunc F() {}\n", "package p\n\nfunc G() {}\n", exercise_files: { "p_test.go" => tests }
  end

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "package p\n\nfunc F( {\n"
  end

  # A rule that drops ";" tokens also matched the contents of the string ";",
  # and kept matching it.
  def test_a_string_holding_a_semicolon
    refute_same_representation "package p\n\nvar S = \";\"\n", "package p\n\nvar S = \":\"\n"
  end
end
