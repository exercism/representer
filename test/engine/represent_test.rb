require_relative "toy_language"

class RepresentTest < Minitest::Test
  def test_renames_names_defined_in_any_file
    result = represent({ "a.rb" => "x = 1", "b.rb" => "y = x" })
    assert_equal "(program\n  (assignment PLACEHOLDER_1 = 1)\n  (assignment PLACEHOLDER_2 = PLACEHOLDER_1))", result.representation
    assert_equal({ "PLACEHOLDER_1" => "x", "PLACEHOLDER_2" => "y" }, result.mapping)
  end

  def test_the_order_of_the_files_makes_no_difference
    one = represent({ "a.rb" => "x = 1", "b.rb" => "y = 2" })
    other = represent({ "a.rb" => "b = 2", "b.rb" => "a = 1" })
    assert_equal one.representation, other.representation
  end

  def test_solution_files_in_other_formats_are_ignored
    result = represent({ "a.rb" => "x", "README.md" => "1" })
    refute_includes result.representation, "README"
  end

  def test_a_solution_with_no_source_files
    error = assert_raises(Representer::CannotRepresent) { represent({ "README.md" => "x" }) }
    assert_equal "no_source_files", error.reason
  end

  # File names are never part of the representation, and the files are
  # sorted by their code.
  def test_file_names_and_order_do_not_matter
    one = Representer::RepresentSolution.("ruby", { "a.rb" => "def f(x) = x + 1\n", "b.rb" => "def g(y) = h(y)\n" })
    other = Representer::RepresentSolution.("ruby", { "z.rb" => "def g(z) = h(z)\n", "c.rb" => "def f(w) = w + 1\n" })
    assert_equal one.representation, other.representation
    refute_includes one.representation, "a.rb"
  end

  def test_code_split_across_files_is_joined
    one = Representer::RepresentSolution.("rust", { "src/lib.rs" => "fn a() -> i32 { 1 }\nfn b() -> i32 { a() }\n" })
    split = Representer::RepresentSolution.("rust",
      { "src/lib.rs" => "fn b() -> i32 { a() }\n", "src/x.rs" => "fn a() -> i32 { 1 }\n" })
    assert_equal one.representation, split.representation
  end

  # An editor chooses the line endings and a byte-order mark, so they must
  # not change the representation, even inside a multi-line string. A NUL
  # byte is replaced, as the website can't store it.
  def test_line_endings_byte_order_marks_and_nul_bytes
    lf = Representer::RepresentSolution.("python", { "a.py" => "x = '''a\nb'''\n" }).representation
    ["x = '''a\r\nb'''\r\n", "x = '''a\rb'''\r", "\uFEFFx = '''a\nb'''\n"].each do |source|
      assert_equal lf, Representer::RepresentSolution.("python", { "a.py" => source }).representation
    end
    basic = Representer::RepresentSolution.("groovy", { "a.groovy" => "\uFEFFint x;\0" }).representation
    assert_equal "int x ; \uFFFD", basic
  end

  def test_test_and_config_files_in_the_solution_are_ignored
    code = { "leap.js" => "export const isLeap = (year) => year % 4 === 0;\n" }
    extras = { "leap.spec.js" => "test('x', () => {});\n", "babel.config.js" => "module.exports = {};\n" }
    assert_equal Representer::RepresentSolution.("javascript", code).representation,
      Representer::RepresentSolution.("javascript", code.merge(extras)).representation
    go = { "leap.go" => "package leap\n\nfunc IsLeap(y int) bool { return y%4 == 0 }\n" }
    go_extras = { "leap_test.go" => "package leap\n\nfunc TestX() {}\n", "embed.go" => "package leap\n\nvar x = 1\n" }
    assert_equal Representer::RepresentSolution.("go", go).representation,
      Representer::RepresentSolution.("go", go.merge(go_extras)).representation
  end

  private
  def represent(files) = Representer::Engine::Represent.(ToyLanguage::Spec, files)
end
