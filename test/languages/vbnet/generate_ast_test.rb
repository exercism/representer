require_relative "stage_helper"

# Tests VB.NET's GenerateAST stage. Each assert_same pair gets the same tree
# from VB.NET's parser, and each refute_same pair gets different trees.
class VBNetGenerateASTTest < Minitest::Test
  include VBNetStages

  def test_layout_and_continuations_make_no_difference
    assert_same "x = a + _\n    b\ny = 1 : z = 2\n", "x = a + b\ny = 1\nz = 2\n"
    assert_same "x = f(a,\n      b)\n", "x = f(a, b)\n"
  end

  def test_names_and_keywords_ignore_case
    assert_same "Total = SUM(Values)\n", "total = sum(values)\n"
    assert_same "IF x > 1 THEN\n  RETURN TRUE\nEND IF\n", "If x > 1 Then\n  Return True\nEnd If\n"
    assert_same "x = [Select] + 1\n", "x = select + 1\n"
  end

  def test_optional_keywords_make_no_difference
    assert_same "If a Then\n  x = 1\nElseIf b Then\n  x = 2\nEnd If\n",
                "If a\n  x = 1\nElse If b\n  x = 2\nEnd If\n"
    assert_same "For i = 1 To 3\n  x = i\nNext i\n", "For i = 1 To 3\n  x = i\nNext\n"
    assert_same "Select Case x\nCase 1\n  y = 1\nEnd Select\n", "Select x\nCase 1\n  y = 1\nEnd Select\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "x = (a * b) / c\n", "x = a * b / c\n"
    refute_same "x = a - (b - c)\n", "x = a - b - c\n"
    assert_same "F(((x)))\n", "F((x))\n"
  end

  def test_an_argument_in_its_own_brackets_is_passed_by_value
    refute_same "F((x))\n", "F(x)\n"
  end

  def test_numbers_are_their_values
    assert_same "x = 1_000 + &H1F + &b1_1\n", "x = 1000 + 31 + 3\n"
    assert_same "x = 1.50 + .5 + 1E3\n", "x = 1.5 + 0.5 + 1000.0\n"
    assert_same "x = 10L + 8D\n", "x = 10l + 8.0d\n"
    refute_same "x = 1\n", "x = 1.0\n"
    refute_same "x = 1.5\n", "x = 1.5D\n"
    refute_same "x = 10\n", "x = 10L\n"
  end

  def test_based_integers_have_their_type_and_value
    assert_same "x = &HFFFFFFFF + &h7fffffff + &O17\n", "x = &B11111111111111111111111111111111 + 2147483647 + 15\n"
    refute_same "x = &HFFFFFFFF\n", "x = 4294967295\n"
    assert_same "x = &H100000000\n", "x = 4294967296\n"
    refute_same "x = &HFFFFFFFF\n", "x = &HFFFFFFFFFFFFFFFF\n"
  end

  def test_strings_are_their_values
    assert_same "x = \"say \"\"hi\"\"\"\n", "x = “say ““hi”””\n"
    assert_same "x = $\"{{a}} {n}\"\n", "x = $\"{{a}} {n}\"\n"
    refute_same "x = \"a\"\n", "x = \"A\"\n"
    refute_same "x = \"a\"c\n", "x = \"a\"\n"
    refute_same "x = $\"{n:X}\"\n", "x = $\"{n:x}\"\n"
  end

  def test_keywords_that_change_the_meaning_stay
    refute_same "Do While a\n  x = 1\nLoop\n", "Do Until a\n  x = 1\nLoop\n"
    refute_same "Do While a\n  x = 1\nLoop\n", "Do\n  x = 1\nLoop While a\n"
    refute_same "For Each i In a\n  Exit For\nNext\n", "For Each i In a\n  Continue For\nNext\n"
    refute_same "Do\n  Exit Do\nLoop\n", "Do\n  Exit Sub\nLoop\n"
    refute_same "Dim x As New List(Of Integer)\n", "Dim x = New List(Of Integer)\n"
    refute_same "Dim x As Integer(,)\n", "Dim x As Integer()\n"
    refute_same "ReDim Preserve a(3)\n", "ReDim a(3)\n"
    refute_same "Dim f = Function(x) g(x)\n", "Dim f = Sub(x) g(x)\n"
    refute_same "Select Case x\nCase Is > 1\n  y = 1\nEnd Select\n", "Select Case x\nCase Is < 1\n  y = 1\nEnd Select\n"
    refute_same "Dim x = New With {Key .Name = n}\n", "Dim x = New With {.Name = n}\n"
  end

  private
  # Put the source in a method, unless it is a declaration, because
  # statements can't stand on their own.
  def ast(source) = write(generate_ast("Module M\nSub Run()\n#{source}End Sub\nEnd Module\n"))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
