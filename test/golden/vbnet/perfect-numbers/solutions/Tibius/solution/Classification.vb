''' <summary>
''' Classification according to Nicomachus.
''' </summary>
Public Enum Classification

    ''' <summary>The sum of a given number's divisors minus the number itself is less than the number. e.g. 8 is a deficient number as 1 + 2 + 4 + 8 = 15 - 8 = 7.</summary>
    Deficient
    ''' <summary>The sum of a given number's divisors minus the number itself is equal to the number. e.g. 6 is a perfect number as 1 + 2 + 3 + 6 = 12 - 6 = 6.</summary>
    Perfect
    ''' <summary>The sum of a given number's divisors minus the number itself is greater than the number. e.g. 12 is an abundant number as 1 + 2 + 3 + 4 + 6 + 12 = 28 - 12 = 16.</summary>
    Abundant

End Enum
