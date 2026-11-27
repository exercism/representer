require_relative "stage_helper"

# Tests Go's GenerateAST stage. Each assert_same pair gets the same tree from
# Go's parser (go/ast, comparing each value and ignoring positions and
# comments), and each refute_same pair gets different trees. The last test
# lists the pairs where this stage deliberately differs from the parser.
class GoGenerateASTTest < Minitest::Test
  include GoStages

  def test_drops_comments_and_layout
    assert_same in_function("x := 1 // one\n/* two */"), in_function("x := 1")
    assert_same in_function("a := 1; b := 2"), in_function("a := 1\nb := 2")
  end

  def test_keeps_the_semicolons_of_a_for_clause
    refute_same in_function("for i++; ; {\n}"), in_function("for ; ; i++ {\n}")
  end

  def test_keeps_which_bound_of_a_slice_is_given
    refute_same in_function("_ = xs[1:]"), in_function("_ = xs[:1]")
  end

  def test_keeps_the_direction_of_a_channel
    refute_same in_function("var c chan<- int"), in_function("var c <-chan int")
  end

  def test_numbers_are_their_values
    assert_same "package p\n\nconst C = 1_000 + 0x1F + 0o17\n", "package p\n\nconst C = 1000 + 31 + 15\n"
    assert_same "package p\n\nconst C = 017\n", "package p\n\nconst C = 15\n"
    assert_same "package p\n\nconst C = 1.50\n", "package p\n\nconst C = 1.5\n"
    refute_same "package p\n\nconst C = 1.0\n", "package p\n\nconst C = 1\n"
  end

  def test_grouped_specs_belong_to_their_declaration
    assert_same "package p\n\nvar (\n\ta = 1\n)\n", "package p\n\nvar a = 1\n"
    assert_same "package p\n\nimport (\n\t\"fmt\"\n)\n", "package p\n\nimport \"fmt\"\n"
  end

  def test_the_names_a_declaration_defines_are_in_a_list
    assert_includes ast("package p\n\nvar a, b int\n"), "(var_spec\n      (identifier_list a b) int)"
    assert_includes ast(in_function("a, b := f()")), "(identifier_list a b) :="
    assert_includes ast(in_function("for k, v := range m {\n}")), "(identifier_list k v) :="
  end

  def test_the_blank_identifier_has_its_own_type
    types = []
    generate_ast(in_function("for _, v := range m {\n}")).each_descendant { |node| types << node.type if node.text == "_" }
    assert_equal ["blank_identifier"], types
  end

  # go/ast keeps a string as it is written, and a pair of brackets that only
  # groups, and this stage drops both. The tree's shape still shows the
  # grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same in_function("s := \"a\\nb\""), in_function("s := `a\nb`")
    assert_same in_function('s := "\\x41\\u00e9"'), in_function('s := "Aé"')
    refute_same in_function('s := "\\xff"'), in_function('s := "\\xfe"')
    refute_same in_function('s := `\\n`'), in_function('s := "\\n"')
    refute_same in_function('s := `\\xff`'), in_function('s := "\\xff"')
    assert_same in_function("x := (1 + 2)"), in_function("x := 1 + 2")
    refute_same in_function("x := (1 + 2) * 3"), in_function("x := 1 + 2 * 3")
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
