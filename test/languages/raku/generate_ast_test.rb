require_relative "stage_helper"

# Tests Raku's GenerateAST stage. Each assert_same pair means the same to
# Raku's parser (Rakudo), ignoring comments, spacing and the way each value
# is written, and each refute_same pair means something different.
class RakuGenerateASTTest < Minitest::Test
  include RakuStages

  def test_drops_comments_and_pod
    assert_same "# note\n=begin pod\ndocs\n=end pod\nsub f($x) { #`(inline) $x }", "sub f($x) { $x }"
  end

  def test_drops_semicolons_and_brackets_that_only_group
    assert_same "sub f($x, $y) { $x + $y; }", "sub f($x, $y) { ($x + $y) }"
    assert_same "sub f($x) { if ($x) { 1 } }", "sub f($x) { if $x { 1 } }"
  end

  def test_integers_and_rats_are_their_values
    assert_same "say $x + 1_000 + 0x1F;", "say $x + 1000 + 31;"
    assert_same "say $x * 1.50;", "say $x * 1.5;"
    refute_same "say 1000;", "say 100;"
    refute_same "say $x * 1.0;", "say $x * 1;"
  end

  def test_a_num_keeps_its_text
    refute_same "say $x * 1e0;", "say $x * 1.0;"
  end

  def test_strings_are_their_values
    assert_same "say 'a b';", 'say "a b";'
    assert_same "say 'it\\'s';", 'say "it\'s";'
    assert_same "say ‘a’;", "say 'a';"
    assert_same 'say "a\\nb";', "say \"a\nb\";"
    refute_same "say 'a\\nb';", 'say "a\\nb";'
    refute_same "say 'a';", "say 'b';"
  end

  def test_a_string_with_interpolation_or_another_escape_keeps_its_structure
    refute_same 'say "a $x";', "say 'a $x';"
    refute_same 'say "\\x41";', "say 'A';"
  end

  def test_removes_the_indentation_of_each_heredoc
    assert_same "my $x = q:to/END/;\n        hello\n          world\n        END\n",
      "my $x = q:to/END/;\n    hello\n      world\n    END\n"
    refute_same "my $x = q:to/END/;\n    hello\n      world\n    END\n",
      "my $x = q:to/END/;\n    hello\n    world\n    END\n"
  end

  def test_each_variable_has_the_type_of_its_sigil
    assert_equal [["scalar", "$a"], ["array", "@b"], ["hash", "%c"], ["code", "&d"], ["public_attribute", "$.e"]],
      variables("f($a, @b, %c, &d, $.e);")
  end

  def test_marks_each_pragma
    assert_equal "(source_file\n  (pragma v6)\n  (pragma lib \"lib\")\n  (pragma MONKEY-SEE-NO-EVAL)\n  (use_statement Test))",
      ast("use v6;\nuse lib 'lib';\nuse MONKEY-SEE-NO-EVAL;\nuse Test;")
  end

  private
  def ast(source) = write(generate_ast(source))

  # The type and text of each leaf that holds a variable.
  def variables(source)
    leaves = []
    generate_ast(source).each_descendant { |node| leaves << [node.type, node.text] if node.leaf? && node.text&.match?(/\A[$@%&]/) }
    leaves
  end

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
