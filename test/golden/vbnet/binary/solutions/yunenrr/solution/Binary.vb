Public Class Binary
    Private ReadOnly BinaryNumber As String
    Private ReadOnly IsABinaryNumber As Boolean
    Private ReadOnly NumberSize As Integer
  
    Public Sub New(value As String)
      BinaryNumber = value
      IsABinaryNumber = IsAValidNumber()
      NumberSize = value.Length()-1
    End Sub

    Public Function ToDecimal() As Integer
      If Not IsABinaryNumber Then 
        Return 0
      End If

	  Dim theLength As Integer = NumberSize
	  Dim theResult As Integer = 0
		
	  For thePosition As Integer = 0 To NumberSize
		If BinaryNumber(thePosition) = "1" Then
		  theResult += 1 << theLength
		End If
        
          theLength -= 1
	  Next

      Return theResult
    End Function

    Private Function IsAValidNumber() As boolean
      For Each theDigit As Char In BinaryNumber
        If IsAnInvalidBinary(theDigit) Then
          Return False
        End If  
      Next
      Return True
    End Function

	Private Function IsAnInvalidBinary(theValue As Char) As Boolean
	  Return theValue <> "0" AndAlso theValue <> "1"
	End Function
End Class