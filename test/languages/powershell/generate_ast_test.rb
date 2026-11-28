require_relative "stage_helper"

# Tests PowerShell's GenerateAST stage. Each assert_same pair gets the same
# tree from PowerShell's own parser, and each refute_same pair gets different
# trees.
class PowershellGenerateASTTest < Minitest::Test
  include PowershellStages

  def test_layout_and_line_continuations_make_no_difference
    assert_same "$x = 1; $y = 2", "$x = 1\n$y = 2"
    assert_same "Get-Thing -A 1 `\n  -B 2", "Get-Thing -A 1 -B 2"
    assert_same "$h = @{ a = 1; b = 2 }", "$h = @{\n  a = 1\n  b = 2\n}"
  end

  def test_names_and_keywords_ignore_case
    assert_same "IF ($X -EQ 1) { RETURN $X }", "if ($x -eq 1) { return $x }"
    assert_same "Write-Host $Total.Length", "write-host $total.length"
    assert_same "[Math]::Max([INT]$a, 2)", "[math]::max([int]$a, 2)"
    assert_same "Get-Thing -Name $x", "Get-Thing -name $x"
  end

  def test_variables_with_or_without_braces_are_the_same
    assert_same "$x = ${count} + 1", "$x = $count + 1"
    refute_same "$global:count = 1", "$count = 1"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "$x = ($a * $b) / $c", "$x = $a * $b / $c"
    assert_same "return (($y % 4 -eq 0) -and ($y % 100 -ne 0))", "return $y % 4 -eq 0 -and ($y % 100 -ne 0)"
    assert_same "Write-Host ($x)", "Write-Host $x"
    refute_same "$x = $a - ($b - $c)", "$x = $a - $b - $c"
    refute_same "$x = ((1, 2), 3)", "$x = (1, 2, 3)"
  end

  def test_brackets_around_commands_and_assignments_stay
    refute_same "($x = 1)", "$x = 1"
    refute_same "Write-Host (Get-Date)", "Write-Host Get-Date"
    refute_same "$x = (Get-Date) | Out-String", "$x = Get-Date | Out-String"
  end

  def test_empty_brackets_after_a_function_name_make_no_difference
    assert_same "function f() { 1 }", "function f { 1 }"
    refute_same "function f($x) { 1 }", "function f { 1 }"
  end

  def test_numbers_are_their_values
    assert_same "$x = 1.50 + 1e3", "$x = 1.5 + 1000.0"
    assert_same "$x = 0x1F", "$x = 31"
    assert_same "$x = 10L", "$x = 10l"
    assert_same "$x = 1.50d", "$x = 1.5d"
    refute_same "$x = 1", "$x = 1.0"
    refute_same "$x = 1.5", "$x = 1.5d"
    refute_same "$x = 0xFFFFFFFF", "$x = 4294967295"
  end

  def test_strings_are_their_values
    assert_same "$x = 'it''s'", "$x = \"it's\""
    assert_same "$x = \"say \"\"hi\"\"\"", "$x = 'say \"hi\"'"
    assert_same "$x = \"a`tb`$c\"", "$x = 'a\tb$c'"
    assert_same "$x = @'\nhello\n'@", "$x = 'hello'"
    assert_same "$x = @\"\nhi $name\n\"@", "$x = \"hi $name\""
    assert_same "Write-Host hello", "Write-Host 'hello'"
    assert_same "$h = @{ a = 1 }", "$h = @{ 'a' = 1 }"
    refute_same "$x = 'a'", "$x = 'A'"
    refute_same "$x = '$y'", "$x = \"$y\""
    refute_same "Write-Host Hello", "Write-Host hello"
  end

  def test_tokens_that_change_the_meaning_stay
    refute_same "do { $i++ } while ($i -lt 3)", "do { $i++ } until ($i -lt 3)"
    refute_same "function f { 1 }", "filter f { 1 }"
    refute_same "f -Force:$false", "f -Force $false"
    refute_same "$x = ,$a", "$x = $a"
    refute_same "[int[]]$x = 1", "[int]$x = 1"
    refute_same "$x = $a.b", "$x = $a::b"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
