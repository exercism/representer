require_relative "stage_helper"

# Tests Go's Normalise stage, through Rosetta as a whole, because the
# names it writes are renamed afterwards.
class GoNormaliseTest < RosettaTest
  include GoStages

  track "go"

  def test_drops_the_package_clause
    assert_same_representation "package a\n\nfunc F() {}\n", "package b\n\nfunc F() {}\n"
  end

  def test_grouped_types_and_vars_are_separate_declarations
    assert_same_representation "package p\n\ntype (\n\tA int\n\tB string\n)\n", "package p\n\ntype A int\ntype B string\n"
    assert_same_representation "package p\n\nvar (\n\ta = 1\n\tb = 2\n)\n", "package p\n\nvar a = 1\nvar b = 2\n"
  end

  def test_const_groups_stay_whole
    refute_same_representation "package p\n\nconst (\n\ta = iota\n\tb\n)\n", "package p\n\nconst a = iota\nconst b\n"
  end

  def test_var_without_value_is_zero_value
    assert_same_representation in_function("var a int"), in_function("a := 0")
    assert_same_representation in_function("var a string"), in_function("a := \"\"")
    assert_same_representation in_function("var a bool"), in_function("a := false")
    assert_same_representation in_function("var a float64"), in_function("a := 0.0")
    assert_same_representation in_function("var a complex128"), in_function("a := 0i")
    assert_same_representation in_function("var a uint8"), in_function("a := uint8(0)")
    assert_same_representation in_function("var a byte"), in_function("a := byte(0)")
    assert_same_representation in_function("var a rune"), in_function("a := rune(0)")
  end

  def test_every_builtin_numeric_type_has_a_zero_value
    %w[int8 int16 int32 int64 uint uint8 uint16 uint32 uint64 uintptr byte rune
       float32 complex64].each do |type|
      assert_same_representation in_function("var a #{type}"), in_function("a := #{type}(0)")
    end
  end

  def test_var_with_value
    assert_same_representation in_function("var a int = 1"), in_function("a := 1")
    assert_same_representation in_function("var a = 1"), in_function("a := 1")
    assert_same_representation in_function("var a int64 = 1"), in_function("a := int64(1)")
    assert_same_representation in_function("var a int64 = int64(1)"), in_function("a := int64(1)")
    assert_same_representation in_function("var a rune = 'x'"), in_function("a := 'x'")
  end

  def test_var_with_a_literal_of_another_type_is_converted
    assert_same_representation in_function("var a float64 = 1"), in_function("a := float64(1)")
    refute_same_representation in_function("var a float64 = 1"), in_function("a := 1")
    refute_same_representation in_function("var a int"), in_function("a := 0.0")
  end

  def test_var_groups_and_lists_become_separate_declarations
    assert_same_representation in_function("var (\n a int\n b = 2\n)"), in_function("a := 0\nb := 2")
    assert_same_representation in_function("var a, b int"), in_function("a := 0\nb := 0")
    assert_same_representation in_function("var a, b = 1, 2"), in_function("a := 1\nb := 2")
  end

  def test_var_that_cant_be_rewritten_stays_a_var
    refute_same_representation in_function("var e error"), in_function("e := 0")
    refute_same_representation in_function("var xs []int"), in_function("xs := 0")
    refute_same_representation in_function("var t T"), in_function("t := 0")
    refute_same_representation in_function("var a, b = f()"), in_function("a := 0\nb := 0")
    refute_same_representation in_function("var _ = f()"), in_function("_ := f()")
  end

  def test_var_values_that_read_an_outer_name_stay_a_var
    refute_same_representation in_function("var a, b = 1, a"), in_function("a := 1\nb := a")
  end

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
    assert_same_representation in_function("var sb strings.Builder"), in_function("sb := strings.Builder{}")
    assert_same_representation in_function("var mu sync.Mutex"), in_function("mu := sync.Mutex{}")
    assert_same_representation in_function("var b bytes.Buffer"), in_function("b := bytes.Buffer{}")
    assert_same_representation in_function("var d time.Duration"), in_function("d := time.Duration(0)")
    assert_same_representation in_function("var wg sync.WaitGroup"), in_function("wg := sync.WaitGroup{}")
    refute_same_representation in_function("var mu sync.Mutex"), in_function("mu := sync.RWMutex{}")
    refute_same_representation in_function("var f os.File"), in_function("f := os.File{}")
  end

  def test_package_level_var_is_not_rewritten
    refute_same_representation "package p\n\nvar a int\n", "package p\n\nvar a = 0\n"
  end

  private
  def defining(type, body) = "package p\n\ntype T #{type}\n\nfunc F() {\n#{body}\n}\n"
end
