Imports System

Public Module VariableLengthQuantity

    Public Function Encode(ByVal numbers As UInteger()) As UInteger()

        Return numbers.SelectMany(Function(num) EncodeNumber(num)).ToArray

    End Function

    Public Function Decode(bytes As UInteger()) As UInteger()

        Dim result As New List(Of UInteger)
        Dim value As UInteger = 0UI

        For Each b In bytes

            value = (value << 7) Or (b And &H7FUI)

            If (b And &H80UI) = 0UI Then
                result.Add(value)
                value = 0UI
            End If

        Next

        If value <> 0UI OrElse (bytes.Last() And &H80UI) <> 0UI Then
            Throw New InvalidOperationException("VLQ incompleto")
        End If

        Return result.ToArray()

    End Function

    Private Function EncodeNumber(number As UInteger) As List(Of UInteger)

        If number = 0UI Then Return New List(Of UInteger) From {0UI}
    
        Dim bytes As New List(Of UInteger)

        While number >= 0
            Dim b = number And &H7FUI
            bytes.Add(b)
            number >>= 7
        End While

        bytes.Reverse()

        For i = 0 To bytes.Count - 2
            bytes(i) = bytes(i) Or &H80UI
        Next

        Return bytes

    End Function

End Module