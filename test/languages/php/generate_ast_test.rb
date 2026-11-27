require_relative "stage_helper"

# Tests PHP's GenerateAST stage. Each assert_same pair gets the same tree from
# PHP's parser (nikic/php-parser, ignoring comments, spacing and the way each
# value is written), and each refute_same pair gets different trees. The last
# test lists the pairs where this stage deliberately differs from the parser.
class PHPGenerateASTTest < Minitest::Test
  include PHPStages

  def test_drops_comments_layout_and_the_text_around_the_code
    assert_same "<?php\n$a = 1; // one\n/* two */\n# three\n", "<?php $a=1;"
    assert_same "<h1>Hi</h1>\n<?php\n$a = 1;\n?>\n<p>Bye</p>\n", "<?php $a = 1;"
    assert_same "<?php\n$a = 1;;\n", "<?php $a = 1;"
  end

  def test_strings_are_their_values
    assert_same "<?php $a = 'it\\'s \\\\ \\n';", "<?php $a = \"it's \\\\ \\\\n\";"
    assert_same "<?php $a = \"\\x41\\101\\u{41}\\t\";", "<?php $a = \"AAA\t\";"
    assert_same "<?php $a = \"\\q\";", "<?php $a = '\\q';"
    refute_same "<?php $a = 'a\\nb';", "<?php $a = \"a\\nb\";"
    refute_same "<?php $a = \"\\xFF\";", "<?php $a = \"\\u{FF}\";"
    refute_same "<?php $a = \"\\xFF\";", "<?php $a = '\\xFF';"
  end

  def test_heredocs_and_nowdocs_are_their_values
    assert_same "<?php\n$a = <<<EOT\n    one\n      two\n    EOT;\n", "<?php $a = \"one\\n  two\";"
    assert_same "<?php\n$a = <<<'EOT'\n  one\n  two\n  EOT;\n", "<?php $a = 'one\ntwo';"
    assert_same "<?php\n$a = <<<EOT\none $b\nEOT;\n", "<?php $a = \"one $b\";"
    assert_same "<?php\n$a = <<<EOT\nEOT;\n", "<?php $a = '';"
    refute_same "<?php\n$a = <<<EOT\none\ntwo\nEOT;\n", "<?php $a = 'onetwo';"
  end

  def test_numbers_are_their_values
    assert_same "<?php $a = 1_000 + 0x1F + 0b11 + 017 + 0o17;", "<?php $a = 1000 + 31 + 3 + 15 + 15;"
    assert_same "<?php $a = 1.50 + 1.5e3;", "<?php $a = 1.5 + 1500.0;"
    refute_same "<?php $a = 1;", "<?php $a = 1.0;"
  end

  def test_arrays_can_be_written_with_array
    assert_same "<?php $a = array(1, 'b' => 2);", "<?php $a = [1, 'b' => 2];"
    refute_same "<?php list($a, $b) = $c;", "<?php [$a, $b] = $c;"
  end

  def test_every_exit_is_a_call_to_exit
    assert_same "<?php exit;", "<?php exit();"
    assert_same "<?php die;", "<?php exit();"
    assert_same "<?php die(1);", "<?php exit(1);"
    assert_same "<?php DIE('a');", "<?php exit('a');"
    refute_same "<?php exit(1);", "<?php exit();"
  end

  def test_new_needs_no_brackets
    assert_same "<?php $a = new Foo;", "<?php $a = new Foo();"
    refute_same "<?php $a = new Foo(1);", "<?php $a = new Foo();"
  end

  def test_each_cast_has_its_main_name
    assert_same "<?php $a = (integer) $b + (boolean) $b + (double) $b + (real) $b + (binary) $b;",
      "<?php $a = (int) $b + (bool) $b + (float) $b + (float) $b + (string) $b;"
    assert_same "<?php $a = (INT) $b;", "<?php $a = (int) $b;"
  end

  def test_a_property_is_one_name_in_its_declaration_and_its_uses
    assert_includes ast("<?php class A { private $count; }"), "(property_element count)"
    assert_includes ast("<?php self::$count;"), ":: count"
    refute_same "<?php $a->count;", "<?php $a->$count;"
  end

  def test_a_variable_in_braces_in_a_string_is_the_variable
    assert_same "<?php $a = \"x ${b}\";", "<?php $a = \"x $b\";"
    assert_same "<?php $a = \"x {$b}\";", "<?php $a = \"x $b\";"
  end

  # These semicolons and keywords are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "<?php for (;; $i++) {}", "<?php for ($i++;;) {}"
    refute_same "<?php for (; $i++;) {}", "<?php for ($i++;;) {}"
  end

  # The parser keeps brackets that only group, and the representation has
  # never kept them, so this stage drops them too. The tree's shape still
  # shows the grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same "<?php $a = ($b * 2) + 1;", "<?php $a = $b * 2 + 1;"
    refute_same "<?php $a = $b * (2 + 1);", "<?php $a = $b * 2 + 1;"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
