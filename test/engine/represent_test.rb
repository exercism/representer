require "test_helper"

# Checks that the engine stops a solution with no representation, and never
# raises, when a language's rules hit one of its limits.
class RepresentTest < Minitest::Test
  # A rule that returns the node it matched, unchanged, keeps matching it.
  class SameNode < Representer::Language
    version 2
    grammar "ruby"
    extensions ".rb"
    names :identifier
    rewrite("(integer) @number", &:node)
  end

  # Two rules that undo each other keep replacing the node.
  class Oscillating < Representer::Language
    version 2
    grammar "ruby"
    extensions ".rb"
    names :identifier
    rewrite("(integer) @number") { |match| leaf(:float, match.node.text) }
    rewrite("(float) @number") { |match| leaf(:integer, match.node.text) }
  end

  def test_a_rule_that_keeps_matching_its_own_output
    [SameNode, Oscillating].each do |language|
      error = assert_raises(Representer::CannotRepresent) { language.({ "a.rb" => "x = 1" }, {}) }
      assert_equal "too_complex", error.reason
    end
  end

  def test_solution_files_in_other_formats_are_ignored
    result = SameNode.({ "a.rb" => "x", "README.md" => "1" }, {})
    refute_includes result.representation, "README"
  end

  def test_a_solution_with_no_source_files
    error = assert_raises(Representer::CannotRepresent) { SameNode.({ "README.md" => "x" }, {}) }
    assert_equal "no_source_files", error.reason
  end

  # File names are never part of the representation, and the files are
  # sorted by their code.
  def test_file_names_and_order_do_not_matter
    one = Representer::RepresentSolution.("ruby", { "a.rb" => "def f(x) = x + 1\n", "b.rb" => "def g(y) = h(y)\n" }, {})
    other = Representer::RepresentSolution.("ruby", { "z.rb" => "def g(z) = h(z)\n", "c.rb" => "def f(w) = w + 1\n" }, {})
    assert_equal one.representation, other.representation
    refute_includes one.representation, "a.rb"
  end

  def test_code_split_across_files_is_joined
    one = Representer::RepresentSolution.("rust", { "src/lib.rs" => "fn a() -> i32 { 1 }\nfn b() -> i32 { a() }\n" }, {})
    split = Representer::RepresentSolution.("rust",
      { "src/lib.rs" => "fn b() -> i32 { a() }\n", "src/x.rs" => "fn a() -> i32 { 1 }\n" }, {})
    assert_equal one.representation, split.representation
  end

  # The config says which exercise file is the stub, whatever the student
  # called their own file. A staged language such as Ruby ignores the
  # exercise's files, so this uses Python.
  def test_a_stub_with_another_name_only_keeps_its_members
    stub = "def greet(who):\n    pass\n"
    config = { "files" => { "solution" => ["greet.py"], "test" => ["greet_test.py"] } }.to_json
    exercise = { "greet.py" => stub, ".meta/config.json" => config }
    same_name = Representer::RepresentSolution.("python", { "greet.py" => "def greet(who):\n    return who\n" }, exercise)
    other_name = Representer::RepresentSolution.("python", { "hello.py" => "def greet(who):\n    return who\n" }, exercise)
    assert_equal({ "PLACEHOLDER_1" => "who" }, other_name.mapping)
    assert_equal same_name.representation, other_name.representation
  end

  # An editor chooses the line endings and a byte-order mark, so they must
  # not change the representation, even inside a multi-line string. A NUL
  # byte is replaced, as the website can't store it.
  def test_line_endings_byte_order_marks_and_nul_bytes
    lf = Representer::RepresentSolution.("python", { "a.py" => "x = '''a\nb'''\n" }, {}).representation
    ["x = '''a\r\nb'''\r\n", "x = '''a\rb'''\r", "\uFEFFx = '''a\nb'''\n"].each do |source|
      assert_equal lf, Representer::RepresentSolution.("python", { "a.py" => source }, {}).representation
    end
    basic = Representer::RepresentSolution.("c", { "a.c" => "\uFEFFint x;\0" }, {}).representation
    assert_equal "int x ; \uFFFD", basic
  end

  def test_test_and_config_files_in_the_solution_are_ignored
    code = { "leap.js" => "export const isLeap = (year) => year % 4 === 0;\n" }
    extras = { "leap.spec.js" => "test('x', () => {});\n", "babel.config.js" => "module.exports = {};\n" }
    assert_equal Representer::RepresentSolution.("javascript", code, {}).representation,
      Representer::RepresentSolution.("javascript", code.merge(extras), {}).representation
    go = { "leap.go" => "package leap\n\nfunc IsLeap(y int) bool { return y%4 == 0 }\n" }
    go_extras = { "leap_test.go" => "package leap\n\nfunc TestX() {}\n", "embed.go" => "package leap\n\nvar x = 1\n" }
    assert_equal Representer::RepresentSolution.("go", go, {}).representation,
      Representer::RepresentSolution.("go", go.merge(go_extras), {}).representation
  end
end
