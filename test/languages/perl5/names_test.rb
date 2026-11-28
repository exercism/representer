require_relative "stage_helper"

# Checks Perl's declarations of which nodes are names and which nodes define
# them (see perl5/representation.rb), through the engine's renaming.
class Perl5NamesTest < Minitest::Test
  include Perl5Stages

  def test_renames_subs_and_their_parameters
    source = "sub area ($width, $height = 1, @rest) { return $width * $height }\nsay area(2, 3);"
    assert_equal %w[area height rest width], renamed(source)
  end

  def test_renames_declared_variables
    source = "my ($x, @y) = @_;\nour %seen;\nstate $count = 0;\nfor my $item (@y) { $seen{$item}++ }\n" \
             "for my ($k, $v) (%seen) { say $k }"
    assert_equal %w[count item k seen v x y], renamed(source)
  end

  def test_renames_packages_methods_constants_and_labels
    source = "package Shape;\nuse constant PI => 3.14;\nuse constant { SIDES => 4 };\n" \
             "sub new { bless {}, shift }\nsub area { PI * SIDES }\n" \
             "OUTER: for my $i (1 .. 3) { next OUTER }\nmy $s = Shape->new;\n$s->area;"
    assert_equal %w[OUTER PI SIDES Shape area i new s], renamed(source)
  end

  def test_renames_classes_fields_and_methods
    source = "class Counter;\nfield $count :param = 0;\nmethod increment { $count++ }"
    assert_equal %w[Counter count increment], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "my $total = sum(@ARGV) + $_ + $a;\nprint STDERR $total;\nour @ISA = ('Base');\nour $VERSION = 1;"
    assert_equal %w[total], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Perl5::Representation::Spec)
    leaves = []
    tree.each_descendant do |node|
      leaves << Perl5::Representation::Spec.name_text(node) if Perl5::Representation::Spec.name?(node) && node.renamed
    end
    leaves.uniq.sort
  end
end
