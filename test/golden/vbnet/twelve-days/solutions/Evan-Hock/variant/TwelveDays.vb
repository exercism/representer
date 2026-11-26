Public Module TwelveDays
    Private Structure VerseInfo
        Public Shared Property Verses = {
            New VerseInfo(number:=0, ordinal:="first", cardinal:="a", giftItem:="Partridge in a Pear Tree"),
            New VerseInfo(number:=1, ordinal:="second", cardinal:="two", giftItem:="Turtle Doves"),
            New VerseInfo(number:=2, ordinal:="third", cardinal:="three", giftItem:="French Hens"),
            New VerseInfo(number:=3, ordinal:="fourth", cardinal:="four", giftItem:="Calling Birds"),
            New VerseInfo(number:=4, ordinal:="fifth", cardinal:="five", giftItem:="Gold Rings"),
            New VerseInfo(number:=5, ordinal:="sixth", cardinal:="six", giftItem:="Geese-a-Laying"),
            New VerseInfo(number:=6, ordinal:="seventh", cardinal:="seven", giftItem:="Swans-a-Swimming"),
            New VerseInfo(number:=7, ordinal:="eighth", cardinal:="eight", giftItem:="Maids-a-Milking"),
            New VerseInfo(number:=8, ordinal:="ninth", cardinal:="nine", giftItem:="Ladies Dancing"),
            New VerseInfo(number:=9, ordinal:="tenth", cardinal:="ten", giftItem:="Lords-a-Leaping"),
            New VerseInfo(number:=10, ordinal:="eleventh", cardinal:="eleven", giftItem:="Pipers Piping"),
            New VerseInfo(number:=11, ordinal:="twelfth", cardinal:="twelve", giftItem:="Drummers Drumming")
        }

        Public number As Integer
        Public ordinal As String
        Public cardinal As String
        Public giftItem As String

        Private Sub New(number, ordinal, cardinal, giftItem)
            Me.number = number
            Me.ordinal = ordinal
            Me.cardinal = cardinal
            Me.giftItem = giftItem
        End Sub

        Public ReadOnly Property Gift As String
            Get
                Return $"{cardinal} {giftItem}"
            End Get
        End Property

        Public ReadOnly Property Gifts As String
            Get
                If number = 0 Then
                    Return Verses(0).Gift
                End If

                Dim giftList(number + 1) As String
                For i = number To 1 Step -1
                    giftList(number - i) = Verses(i).Gift
                Next

                Return Join(giftList, ", ") + $", and {Verses(0).Gift}"
            End Get
        End Property

        Public ReadOnly Property Text As String
            Get
                Return $"On the {ordinal} day of Christmas my true love gave to me: {Gifts}."
            End Get
        End Property
    End Structure

    Public Function Recite(verseNumber As Integer) As String
        Return Recite(verseNumber, verseNumber)
    End Function

    Public Function Recite(startVerse As Integer, endVerse As Integer) As String
        Dim lines(endVerse - startVerse) As String
        For i = 0 To lines.GetUpperBound(0)
            lines(i) = VerseInfo.Verses(startVerse + i - 1).Text
        Next

        Return Join(lines, vbLf)
    End Function
End Module
