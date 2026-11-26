Imports System
Imports Newtonsoft.Json

Public Class RestApi

    Private ReadOnly _users As List(Of User)

    Public Sub New(ByVal database As String)
        _users = JsonConvert.DeserializeObject(Of List(Of User))(database)
    End Sub

    Public Function [Get](ByVal url As String, ByVal Optional payload As String = Nothing) As String

        If payload = "[]" Then
            Return "[]"
        End If

        If payload Is Nothing Then
            Return JsonConvert.SerializeObject(_users)
        End If

        Dim request =
            JsonConvert.DeserializeObject(Of Dictionary(Of String, List(Of String)))(payload)

        Dim names = request("users")

        Return JsonConvert.SerializeObject(_users.Where(Function(user) names.Contains(user.Name)))

    End Function

    Public Function Post(ByVal url As String, ByVal payload As String) As String

        If url = "/iou" Then
            Return CreateIou(payload)
        End If

        Dim request =
            JsonConvert.DeserializeObject(Of Dictionary(Of String, String))(payload)

        Dim user = New User With {.Name = request("user")}

        _users.Add(user)

        Return JsonConvert.SerializeObject(user)

    End Function

    Private Function CreateIou(ByVal payload As String) As String

        Dim transaction = JsonConvert.DeserializeObject(Of Transaction)(payload)

        Dim lender = FindUser(transaction.Lender)
        Dim borrower = FindUser(transaction.Borrower)

        lender.UpdateDebtors(transaction.Borrower, transaction.Amount)
        borrower.UpdateCreditors(transaction.Lender, transaction.Amount)

        Return JsonConvert.SerializeObject({lender, borrower}.OrderBy(Function(user) user.Name))

    End Function

    Private Function FindUser(ByVal name As String) As User
        Return _users.First(Function(user) user.Name = name)
    End Function

End Class

Public Class User

    Public Property Name As String
    Public Property Owes As New SortedDictionary(Of String, Integer)
    Public Property OwedBy As New SortedDictionary(Of String, Integer)

    Public ReadOnly Property Balance As Integer
        Get
            Return OwedBy.Values.Sum() - Owes.Values.Sum()
        End Get
    End Property

    Public Sub UpdateDebtors(ByVal borrower As String, ByVal amount As Integer)

        UpdateDebt(Owes, OwedBy, borrower, amount)

    End Sub

    Public Sub UpdateCreditors(ByVal lender As String, ByVal amount As Integer)

        UpdateDebt(OwedBy, Owes, lender, amount)

    End Sub

    Private Shared Sub UpdateDebt(ByVal debts As SortedDictionary(Of String, Integer), ByVal credits As SortedDictionary(Of String, Integer), ByVal person As String, ByVal amount As Integer)

        Dim currentDebt As Integer = 0

        debts.TryGetValue(person, currentDebt)

        If currentDebt >= amount Then

            If currentDebt = amount Then
                debts.Remove(person)
            Else
                debts(person) = currentDebt - amount
            End If

            Return
        End If

        debts.Remove(person)

        Dim remaining = amount - currentDebt

        Dim currentCredit As Integer = 0
        credits.TryGetValue(person, currentCredit)

        credits(person) = currentCredit + remaining

    End Sub

End Class

Public Class Transaction

    Public Property Lender As String
    Public Property Borrower As String
    Public Property Amount As Integer

End Class