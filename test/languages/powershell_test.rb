require "test_helper"

class PowershellTest < InspectorTest
  track "powershell"

  def test_comments_and_layout_are_ignored
    commented = <<~POWERSHELL
      <#
      .SYNOPSIS
      Says hello.
      #>
      Function Get-Greeting {
          param([string]$Name) # the name
          return "Hello, $Name"
      }
    POWERSHELL
    plain = "function Get-Greeting { param([string]$Name); return \"Hello, $Name\" }\n"
    assert_same_representation commented, plain
  end

  def test_imports_are_dropped
    assert_same_representation "using namespace System.Text\nfunction f { [StringBuilder]::new() }\n",
                               "function f { [StringBuilder]::new() }\n"
  end

  def test_names_the_solution_defines_are_renamed_whatever_their_case
    first = <<~POWERSHELL
      function Test-LeapYear([int]$Year) {
          return $YEAR % 4 -eq 0
      }
    POWERSHELL
    second = <<~POWERSHELL
      function Check-Year([int]$y) {
          RETURN $y % 4 -EQ 0
      }
    POWERSHELL
    assert_same_representation first, second
  end

  def test_names_from_outside_are_kept
    refute_same_representation "function f($s) { $s.ToUpper() }", "function f($s) { $s.ToLower() }"
    refute_same_representation "function f($s) { $s | Sort-Object }", "function f($s) { $s | Sort-Object -Descending }"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "function f($a) { $a + 1 }", "function f($a) { $a - 1 }"
    refute_same_representation "function f($a) { $a -eq 1 }", "function f($a) { $a -ceq 1 }"
    refute_same_representation "function f { 'a' }", "function f { 'b' }"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "function f { $x = ( }\n"
  end
end
