require_relative "stage_helper"

# Checks VB.NET's declarations of which nodes are names and which nodes
# define them (see vbnet/representation/spec.rb), through the engine's
# renaming.
class VBNetNamesTest < Minitest::Test
  include VBNetStages

  def test_renames_types_members_and_parameters
    source = <<~VB
      Namespace Shop
        Public Class Counter(Of T)
          Private Total As Integer
          Public Property Count As Integer
          Public Event Changed()
          Public Function Add(ByVal amount As Integer) As Integer
            Return amount
          End Function
        End Class
        Public Enum Color
          Red
        End Enum
        Public Structure Point
        End Structure
        Public Interface IShape
          Function Area() As Double
        End Interface
      End Namespace
    VB
    assert_equal %w[add amount area changed color count counter ishape point red shop t total], renamed(source)
  end

  def test_renames_local_variables_loop_variables_and_catch_variables
    source = <<~VB
      Module M
        Sub Run()
          Dim Total = 0
          For i = 1 To 3
            total += I
          Next
          For Each item In {1, 2}
          Next
          Try
          Catch e As Exception
          End Try
          Dim words = From word In {"a"} Let size = word.Length Select size
        End Sub
      End Module
    VB
    assert_equal %w[e i item m run size total word words], renamed(source)
  end

  def test_keeps_names_from_the_library
    source = <<~VB
      Module M
        Function F(s As String) As String
          Return String.Join(",", s.Split(" "c).Reverse())
        End Function
      End Module
    VB
    assert_equal %w[f m s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], VBNet::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if VBNet::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
