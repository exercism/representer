require_relative "stage_helper"

# Checks PowerShell's declarations of which nodes are names and which nodes
# define them (see powershell/representation/spec.rb), through the engine's
# renaming.
class PowershellNamesTest < Minitest::Test
  include PowershellStages

  def test_renames_functions_parameters_and_variables
    source = <<~POWERSHELL
      function Get-Total {
        param([int[]]$Values)
        $sum = 0
        foreach ($value in $Values) { $sum += $value }
        return $sum
      }
      Get-Total -Values 1, 2
    POWERSHELL
    assert_equal %w[get-total sum value values], renamed(source)
  end

  def test_renames_names_whatever_their_case
    source = <<~POWERSHELL
      function Test-Leap([int]$Year) { $YEAR % 4 -eq 0 }
      TEST-LEAP -year 2000
    POWERSHELL
    assert_equal [["test-leap"] * 2, ["year"] * 3].flatten, renamed(source, uniq: false)
  end

  def test_renames_classes_properties_methods_and_enums
    source = <<~POWERSHELL
      enum Color { Red; Blue }
      class Shape {
        [int]$Sides
        Shape([int]$n) { $this.Sides = $n }
        [int] Double() { return $this.Sides * 2 }
      }
      [Shape]::new(3).Double()
      [Color]::Red
    POWERSHELL
    assert_equal %w[blue color double n red shape sides], renamed(source)
  end

  def test_renames_splatted_variables
    source = <<~POWERSHELL
      $options = @{ Path = "a" }
      Get-Item @options
    POWERSHELL
    assert_equal %w[options], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = <<~POWERSHELL
      function f($s) {
        $s.ToUpper() | Where-Object { $_ -match 'A' } | Write-Output
        [Math]::Max($true, $null)
      }
    POWERSHELL
    assert_equal %w[f s], renamed(source)
  end

  def test_keeps_hash_keys_and_bare_words_as_strings
    source = <<~POWERSHELL
      $count = 1
      $h = @{ count = 1 }
      Write-Host count
    POWERSHELL
    assert_equal %w[count h], renamed(source)
  end

  private
  # The names that the engine renames, sorted, without the `$`, `@` or `-`
  # before them.
  def renamed(source, uniq: true)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Powershell::Representation::Spec)
    leaves = []
    tree.each_descendant do |node|
      leaves << node.text.sub(/\A[$@-]/, "") if Powershell::Representation::Spec.name?(node) && node.renamed
    end
    uniq ? leaves.uniq.sort : leaves.sort
  end
end
