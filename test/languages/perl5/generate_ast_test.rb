require_relative "stage_helper"

# Tests Perl's GenerateAST stage. Each assert_same pair gets the same tree
# from Perl's parser, and each refute_same pair gets different trees.
class Perl5GenerateASTTest < Minitest::Test
  include Perl5Stages

  def test_layout_and_separators_make_no_difference
    assert_same "sub f { return 1; }", "sub f {\n  return 1\n}"
    assert_same "my %h = (a => 1, b => 2);", "my %h = (a => 1, b => 2,);"
    assert_same "foreach my $x (@list) { say $x }", "for my $x (@list) { say $x }"
    refute_same "for my $x (@list) { say $x }", "for $x (@list) { say $x }"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "my $x = ($a * $b) + $c;", "my $x = $a * $b + $c;"
    assert_same "return (1);", "return 1;"
    assert_same "my @x = (1, 2);", "my @x = (1, (2));"
    refute_same "my $x = ($a + $b) * $c;", "my $x = $a + $b * $c;"
  end

  def test_brackets_that_make_a_list_stay
    refute_same "my ($x) = @list;", "my $x = @list;"
    refute_same "($x) = @list;", "$x = @list;"
    refute_same "my @x = (0) x 3;", "my @x = 0 x 3;"
    refute_same "my @x = @y[0, 1];", "my @x = @y{0, 1};"
  end

  def test_calls_read_the_same_with_or_without_brackets
    assert_same 'print("hi");', 'print "hi";'
    assert_same "my $s = join(', ', @x);", "my $s = join ', ', @x;"
    assert_same "$obj->name();", "$obj->name;"
    refute_same "&foo;", "foo();"
  end

  def test_strings_are_written_as_their_values
    assert_same "my $s = 'a';", 'my $s = "a";'
    assert_same "my $s = q{a};", 'my $s = qq{a};'
    assert_same "my $s = 'it\\'s';", "my $s = \"it's\";"
    assert_same 'my $s = "a\\tb";', "my $s = \"a\tb\";"
    refute_same "my $s = 'a\\n';", 'my $s = "a\\n";'
    refute_same 'my $s = "a\\x41";', 'my $s = "aA";'
    refute_same 'my $s = "$x";', "my $s = $x;"
    refute_same "my $s = '1';", "my $s = 1;"
  end

  def test_word_lists_are_lists_of_strings
    assert_same "my @x = qw(a b);", "my @x = ('a', 'b');"
    assert_same "my @x = ('c', qw(a b));", "my @x = ('c', 'a', 'b');"
    assert_same "my %h = (a => 1);", "my %h = ('a', 1);"
    assert_same "my $v = $h{key};", "my $v = $h{'key'};"
    refute_same "my %h = (a => 1);", "my %h = (a(), 1);"
  end

  def test_heredocs_are_strings
    assert_same "my $s = <<~END;\n  hi $x\n  END\n", "my $s = \"hi $x\\n\";"
    assert_same "my $s = <<'END';\nhi $x\nEND\n", "my $s = 'hi $x\n';"
  end

  def test_regular_expressions_keep_their_text
    assert_same "$x =~ m{a+}i;", "$x =~ /a+/i;"
    assert_same "$x =~ s/a/b/gi;", "$x =~ s/a/b/ig;"
    assert_same "$x =~ y/a-z/A-Z/;", "$x =~ tr/a-z/A-Z/;"
    refute_same "$x =~ /a+/;", "$x =~ /a*/;"
    refute_same "$x =~ /a/;", "$x =~ 'a';"
    refute_same "$x =~ tr/a-z//;", "$x =~ tr/a{z//;"
  end

  def test_numbers_are_written_as_their_values
    assert_same "my $x = 1_000;", "my $x = 1000;"
    assert_same "my $x = 0x1F;", "my $x = 31;"
    assert_same "my $x = 017;", "my $x = 15;"
    assert_same "my $x = 0b101;", "my $x = 5;"
    refute_same "my $x = 1.0;", "my $x = 1;"
    refute_same "my $x = 017;", "my $x = 17;"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
