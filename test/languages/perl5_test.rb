require "test_helper"

class Perl5Test < InspectorTest
  track "perl5"

  def test_comments_and_layout_are_ignored
    assert_same_representation "# Says hello.\nsub hello {\n  # the greeting\n  return 'Hello'; # done\n}\n\n=pod\n\nDocs\n\n=cut\n",
      "sub hello { return 'Hello' }"
  end

  def test_imports_are_dropped
    assert_same_representation "use strict;\nuse warnings;\nuse List::Util qw(sum);\nuse Exporter 'import';\n" \
                               "our @EXPORT_OK = qw(total);\nsub total { sum(@_) }",
      "sub total { sum(@_) }"
  end

  def test_a_module_with_a_version_is_dropped
    assert_same_representation "use List::Util 1.45;\nsub total { List::Util::sum(@_) }",
      "sub total { List::Util::sum(@_) }"
  end

  def test_pragmas_that_change_how_perl_reads_the_code_stay
    refute_same_representation "use v5.38;\nsub f { say 1 }", "sub f { say 1 }"
    refute_same_representation "use integer;\nsub f { 1 / 2 }", "sub f { 1 / 2 }"
    refute_same_representation "use feature 'say';\nsub f { say 1 }", "sub f { say 1 }"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "package Leap;\nsub is_leap ($year) { return $year % 4 == 0 }",
      "package Leap;\nsub leap ($y) { return $y % 4 == 0 }"
    assert_same_representation "sub f { my ($self, %args) = @_; return $self->{name} }",
      "sub g { my ($this, %options) = @_; return $this->{name} }"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "sub f { return uc $_[0] }", "sub f { return lc $_[0] }"
    refute_same_representation "sub f { return sum(@_) }", "sub f { return max(@_) }"
    refute_same_representation "sub f { return $h{name} }", "sub f { return $h{title} }"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "sub f { my ($x) = @_; $x }", "sub f { my $x = @_; $x }"
    refute_same_representation "sub f { $x++ }", "sub f { ++$x }"
    refute_same_representation "sub f { $_[0] eq 'a' }", "sub f { $_[0] == 'a' }"
    refute_same_representation "sub f { @x[0, 1] }", "sub f { @x{0, 1} }"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "sub f { my $x = (\n"
  end
end
