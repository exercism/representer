require "test_helper"

# Tests Inspector as a whole on VB.NET solutions. The tests of each stage are
# in test/languages/vbnet/.
class VBNetTest < InspectorTest
  track "vbnet"

  def test_comments_layout_imports_and_case_go
    commented = <<~VB
      Imports System.Linq
      ' Says if a year is a leap year.
      Public Module Leap
          Public Function IsLeapYear(ByVal year As Integer) As Boolean
              Return year Mod 4 = 0 AndAlso _
                  (year Mod 100 <> 0 OrElse year Mod 400 = 0) ' The rule
          End Function
      End Module
    VB
    plain = <<~VB
      PUBLIC MODULE Leap
      PUBLIC FUNCTION isLeapYear(BYVAL Year AS INTEGER) AS BOOLEAN
      RETURN YEAR MOD 4 = 0 ANDALSO (YEAR MOD 100 <> 0 ORELSE YEAR MOD 400 = 0)
      END FUNCTION
      END MODULE
    VB
    assert_same_representation commented, plain
  end

  def test_names_the_solution_defines_are_renamed
    code = "Public Module %<m>s\n  Public Function %<f>s(ByVal %<p>s As Integer) As Integer\n" \
           "    Dim %<d>s = %<p>s * 2\n    Return %<d>s\n  End Function\nEnd Module\n"
    assert_same_representation format(code, m: "Doubler", f: "Run", p: "input", d: "result"),
                               format(code, m: "Twice", f: "Go", p: "amount", d: "output")
  end

  def test_names_from_the_library_keep_their_names
    refute_same_representation "Module M\n  Function F(s As String) As String\n    Return s.ToUpper()\n  End Function\nEnd Module\n",
                               "Module M\n  Function F(s As String) As String\n    Return s.ToLower()\n  End Function\nEnd Module\n"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_vbnet_version
    assert_basic_representation "Module M\n  Function F( As\n"
  end
end
