Imports System.Text
Imports System.Globalization

Public Class LedgerEntry

    Public Sub New(ByVal date1 As Date, ByVal description As String, ByVal change As Decimal)
        Me.Date1 = date1
        Me.Description = description
        Me.Change = change
    End Sub

    Public ReadOnly Property Date1 As Date
    Public ReadOnly Property Description As String
    Public ReadOnly Property Change As Decimal

End Class

Public Module Ledger

    Public Function CreateEntry(ByVal date1 As String, ByVal description As String, ByVal change As Integer) As LedgerEntry

        Return New LedgerEntry(Date.Parse(date1, CultureInfo.InvariantCulture), description, CDec(change / 100))

    End Function

    Private Function GetCulture(ByVal currency As String, ByVal locale As String) As CultureInfo

        Dim culture As New CultureInfo(locale)

        Select Case locale
            Case "en-US"
                culture.NumberFormat.CurrencyNegativePattern = 0
                culture.DateTimeFormat.ShortDatePattern = "MM/dd/yyyy"

            Case "nl-NL"
                culture.NumberFormat.CurrencyNegativePattern = 12
                culture.DateTimeFormat.ShortDatePattern = "dd/MM/yyyy"

            Case Else
                Throw New ArgumentException("Invalid locale")
        End Select

        Select Case currency
            Case "USD"
                culture.NumberFormat.CurrencySymbol = "$"

            Case "EUR"
                culture.NumberFormat.CurrencySymbol = "€"

            Case Else
                Throw New ArgumentException("Invalid currency")
        End Select

        Return culture

    End Function

    Private Function PrintHeader(ByVal locale As String) As String

        Select Case locale
            Case "en-US"
                Return "Date       | Description               | Change       "
            Case "nl-NL"
                Return "Datum      | Omschrijving              | Verandering  "
            Case Else
                Throw New ArgumentException("Invalid locale")
        End Select

    End Function

    Private Function FormatDate(ByVal culture As IFormatProvider, ByVal d As Date) As String

        Return d.ToString("d", culture)

    End Function

    Private Function FormatDescription(ByVal description As String) As String

        Return If(description.Length > 25, description.Substring(0, 22) & "...", description)

    End Function

    Private Function FormatChange(ByVal culture As IFormatProvider, ByVal change As Decimal) As String

        Dim formatted = change.ToString("C", culture)

        If change < 0D AndAlso Not formatted.Contains("-"c) Then
            Return formatted
        End If

        Return formatted & " "

    End Function

    Private Function PrintEntry(ByVal culture As IFormatProvider, ByVal entry As LedgerEntry) As String

        Return $"{FormatDate(culture, entry.Date1)} | " &
               $"{String.Format("{0,-25}", FormatDescription(entry.Description))} | " &
               $"{String.Format("{0,13}", FormatChange(culture, entry.Change))}"

    End Function

    Private Function Sort(ByVal entries As LedgerEntry()) As IEnumerable(Of LedgerEntry)

        Return entries.
                OrderBy(Function(entry) entry.Date1).
                ThenBy(Function(entry) entry.Description).
                ThenBy(Function(entry) entry.Change)

    End Function

    Public Function Format(ByVal currency As String, ByVal locale As String, ByVal entries As LedgerEntry()) As String

        Dim culture = GetCulture(currency, locale)
        Dim sb As New StringBuilder(PrintHeader(locale))

        For Each entry In Sort(entries)
            sb.AppendLine()
            sb.Append(PrintEntry(culture, entry))
        Next

        Return sb.ToString()

    End Function

End Module
