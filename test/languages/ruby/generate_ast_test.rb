require "test_helper"
require "golden"
require "parser/ruby33"
require "rubocop-ast"

# Tests Ruby's GenerateAST stage on its own, and against the tree that Ruby's
# own parser gives (the parser gem, with RuboCop's builder, as the old
# representer used).
class RubyGenerateASTTest < Minitest::Test
  GenerateAST = Representer::Languages::Ruby::Common::GenerateAST

  def test_drops_comments_and_layout
    assert_same "x = 1 # one\n\n", "x = 1;"
    assert_same "x = 1\n__END__\nsome text\n", "x = 1"
  end

  def test_turns_modifiers_ternaries_and_unless_into_if
    assert_same "x if y", "if y then x end"
    assert_same "x ? a : b", "if x\n  a\nelse\n  b\nend"
    assert_same "unless x\n  a\nelse\n  b\nend", "if x\n  b\nelse\n  a\nend"
    assert_same "y unless x", "if x\nelse\n  y\nend"
    assert_same "if a\n  1\nelsif b\n  2\nend", "if a\n  1\nelse\n  if b\n    2\n  end\nend"
  end

  def test_loops
    assert_same "y while x", "while x do y end"
    assert_same "y until x", "until x\n  y\nend"
    refute_same "begin\n  y\nend while x", "while x\n  y\nend"
  end

  def test_blocks_and_lambdas
    assert_same "xs.map { |x| x }", "xs.map do |x|\n  x\nend"
    assert_same "f = ->(a) { a }", "f = lambda { |a| a }"
    refute_same "xs.each { |a,| a }", "xs.each { |a| a }"
    refute_same "xs.each { |a; b| a }", "xs.each { |a, b| a }"
  end

  def test_methods_and_calls
    assert_same "def f = 1", "def f\n  1\nend"
    assert_same "def f()\nend", "def f\nend"
    assert_same "a.b()", "a.b"
    assert_same "foo()", "foo"
    assert_same "puts(x)", "puts x"
    assert_same "x = A::b", "x = A.b"
    assert_same "f.(x)", "f.call(x)"
    refute_same "super()", "super"
    refute_same "a&.b", "a.b"
  end

  def test_class_and_module_bodies_get_their_own_types
    assert_includes ast("class A\n  def f\n    1\n  end\nend"), "(class_body\n      (method f\n        (body_statement 1)))"
    assert_includes ast("module M\n  X = 1\nend"), "(module_body"
  end

  def test_word_operators
    assert_same "a and b", "a && b"
    assert_same "not a", "!a"
  end

  def test_brackets_that_only_group
    assert_same "x = (1 + 2)", "x = 1 + 2"
    refute_same "x = (a + b) * c", "x = a + b * c"
  end

  def test_hashes_and_symbols
    assert_same "{a: 1}", "{:a => 1}"
    assert_same '{"a": 1}', "{a: 1}"
    assert_same "{a:}", "{a: a}"
    assert_same ':"a"', ":a"
    refute_same '{"a": 1}', '{"a" => 1}'
  end

  def test_numbers
    assert_same "x = 1_000 + 0x1F + 0b1 + 017 + 0d9", "x = 1000 + 31 + 1 + 15 + 9"
    assert_same "x = 1.50e1", "x = 15.0"
    refute_same "x = 1.0", "x = 1"
  end

  def test_strings
    assert_same "x = 'a b'", 'x = "a b"'
    assert_same "x = %q(a)", "x = 'a'"
    assert_same "x = ?a", 'x = "a"'
    assert_same "x = 'it\\'s'", 'x = "it\'s"'
    refute_same "x = 'a\\nb'", 'x = "a\\nb"'
    refute_same "x = \"\\\\u0041\"", "x = \"\\u0041\""
  end

  def test_heredocs
    assert_same "x = <<~EOS\n  a\n    b\nEOS\n", "x = \"a\\n  b\\n\""
    assert_same "x = <<~EOS\n  a\nEOS\n", "x = <<-TEXT\na\n  TEXT\n"
    assert_same "x = <<~EOS\n  a\n  \#{b}\nEOS\n", "x = \"a\\n\#{b}\\n\""
    refute_same "x = <<~EOS\n  \#{b}\nEOS\n", "x = <<~'EOS'\n  \#{b}\nEOS\n"
    assert_same "x = <<~A + <<~B\n  a\nA\n  b\nB\n", "x = \"a\\n\" + \"b\\n\""
  end

  def test_word_and_symbol_arrays
    assert_same "x = %w[a b]", 'x = ["a", "b"]'
    assert_same "x = %i[a b]", "x = [:a, :b]"
  end

  def test_regexes
    assert_same "x = /a/", "x = %r{a}"
    assert_same "x = /a/mi", "x = /a/im"
    refute_same "x = /a/i", "x = /a/"
  end

  ### Against Ruby's parser ###

  # Pairs where this stage deliberately gives a different answer from the
  # parser gem, with the reason.
  UNREAD_ESCAPE = "Only the escapes that solutions use are read. Others stay as written, which can only keep strings apart.".freeze

  PARSER_DIFFERENCES = {
    "x = a[1] ||| x = a.[](1)" => "No golden solution calls an operator method by name, so there is no rule for it.",
    "x = a.! ||| x = !a" => "No golden solution calls an operator method by name, so there is no rule for it.",
    "x = a.+(b) ||| x = a + b" => "No golden solution calls an operator method by name, so there is no rule for it.",
    'x = "\\e[0m" ||| x = "\\033[0m"' => UNREAD_ESCAPE,
    'x = "\\x41" ||| x = "A"' => UNREAD_ESCAPE,
    "[[1, 2]].each { |a,| p a } ||| [[1, 2]].each { |a| p a }" =>
      "`|a,|` takes an array's first element and `|a|` the whole array. The parser gem merges them (a bug), and Prism doesn't."
  }.freeze

  # Each pair in parser_pairs.txt gets the same tree in this stage exactly
  # when the parser gem gives the two snippets the same tree.
  def test_pairs_match_the_parser
    mismatches = parser_pairs.filter_map do |line, first, second|
      ours = ast(first) == ast(second)
      parsers = parser_ast(first) == parser_ast(second)
      next if ours == parsers || PARSER_DIFFERENCES.key?(line)

      "#{line} (parser: #{parsers ? 'same' : 'different'}, GenerateAST: #{ours ? 'same' : 'different'})"
    end
    assert_empty mismatches
  end

  # Within each golden exercise, two solutions get the same tree in this
  # stage, with every name written as a placeholder, exactly when the parser
  # gem gives them the same tree with every name written as a placeholder.
  def test_golden_solutions_match_the_parser
    mismatches = Golden.solutions("ruby").group_by(&:exercise).flat_map do |exercise, solutions|
      sources = solutions.to_h { |solution| [solution.name, solution.files.select { |name, _| name.end_with?(".rb") }.values] }
      sources.select! { |_, files| files.size == 1 }
      ours = sources.transform_values { |(source)| ast(source, names: false) }
      parsers = sources.transform_values { |(source)| parser_ast(source, names: false) }
      sources.keys.combination(2).filter_map do |a, b|
        next if (ours[a] == ours[b]) == (parsers[a] == parsers[b])

        "#{exercise}: #{a} and #{b} (parser: #{parsers[a] == parsers[b] ? 'same' : 'different'})"
      end
    end
    assert_empty mismatches
  end

  # The same, over every input and equivalent.rb of the tests ported from
  # the old representer (test/fixtures/ruby).
  def test_upstream_fixtures_match_the_parser
    sources = Dir[File.join(__dir__, "../../fixtures/ruby/*/*.rb")].sort.to_h { |path| [path[%r{ruby/(.*)}, 1], File.read(path)] }
    ours = sources.transform_values { |source| ast(source, names: false) }
    parsers = sources.transform_values { |source| parser_ast(source, names: false) }
    mismatches = sources.keys.combination(2).reject { |a, b| (ours[a] == ours[b]) == (parsers[a] == parsers[b]) }
    assert_empty mismatches
  end

  private
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))

  # The stage's tree, written out. With names: false, every name is
  # written as its type and a number, in order of appearance.
  def ast(source, names: true)
    # tree-sitter-ruby needs a line break after a heredoc's closing name.
    source = "#{source}\n"
    tree = GenerateAST.(Representer::Engine::Grammar["ruby"].parse(Representer::Engine.clean(source)))
    anonymise_names!(tree) unless names
    Representer::Engine::Serialize.(tree)
  end

  # Gives every name leaf a placeholder of its type and a number, for
  # Serialize to write.
  def anonymise_names!(tree)
    numbers = {}
    names = Representer::Languages::Ruby::Representation::Spec.names
    tree.each_descendant do |leaf|
      prefix = names[leaf.type] if leaf.named? && leaf.leaf?
      leaf.placeholder = "#{leaf.type}:N#{numbers[leaf.text.delete_prefix(prefix)] ||= numbers.size}" if prefix
    end
  end

  # The parser gem's tree, written out, with two changes that the stage
  # makes on purpose:
  #
  # - A `begin` with one child (brackets that only group) is its child.
  # - A heredoc or a string literal is one string. The parser gem splits a
  #   literal that spans several lines into one string per line.
  #
  # With names: false, every name is written as a placeholder.
  def parser_ast(source, names: true)
    parser = Parser::Ruby33.new(RuboCop::AST::Builder.new)
    parser.diagnostics.all_errors_are_fatal = true
    parser.diagnostics.consumer = ->(_) {}
    tree = parser.parse(Parser::Source::Buffer.new("(pair)", source:))
    write(tree, names ? nil : {})
  end

  NAME = /\A[$@]{0,2}[A-Za-z_][A-Za-z0-9_]*[?!=]?\z/

  def write(node, names)
    return write_atom(node, names) unless node.is_a?(Parser::AST::Node)

    children = node.children
    return write(children.first, names) if node.type == :begin && children.one?
    return write(one_string(node), names) if node.type == :dstr && one_literal?(node.location)

    "(#{node.type} #{children.map { |child| write(child, names) }.join(' ')})"
  end

  def write_atom(atom, names)
    return atom.inspect unless names && atom.is_a?(Symbol) && atom.match?(NAME)

    "N#{names[atom] ||= names.size}"
  end

  def one_literal?(location) = location.is_a?(Parser::Source::Map::Heredoc) || location&.begin

  def one_string(node)
    parts = node.children.chunk_while { |a, b| [a, b].all? { |part| part.type == :str } }.map do |run|
      run.first.type == :str ? Parser::AST::Node.new(:str, [run.sum("") { |part| part.children.first }]) : run.first
    end
    parts.one? && parts.first.type == :str ? parts.first : Parser::AST::Node.new(:dstr, parts)
  end

  def parser_pairs
    File.readlines(File.join(__dir__, "parser_pairs.txt"), chomp: true).filter_map do |line|
      next if line.strip.empty? || line.start_with?("#")

      [line, *line.split(" ||| ").map { |part| part.gsub(/\\\\n|\\n/) { |escape| escape == "\\n" ? "\n" : "\\n" } }]
    end
  end
end
