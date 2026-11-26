''' <summary>
''' Module that provides a method to classify positive integers into the <see cref="Classification"/> of Nicomachus.
''' </summary>
Public Module PerfectNumbers

    'Public Methods

    ''' <summary>
    ''' Returns the classification of any given positive Int32 into one of the 3 categories <see cref="Classification.Deficient"/>, 
    ''' <see cref="Classification.Perfect"/> or <see cref="Classification.Abundant"/> according to Nicomachus.
    ''' </summary>
    ''' <param name="number">The positive integer to be categorized.</param>
    ''' <returns>The category according to Nicomachus.</returns>
    ''' <exception cref="ArgumentOutOfRangeException">An ArgumentOutOfRangeException is thrown if the given number is less than 1.</exception>
    Public Function Classify(ByVal number As Int32) As Classification
        If (number < 1) Then Throw New ArgumentOutOfRangeException(NameOf(number), number, $"The {NameOf(number)} must be a positive {NameOf(Int32)}!")
        Dim sum As UInt32 = number.GetAliquotSum()
        Return Classify(number, sum)
    End Function

    'Private Methods

    Private Function Classify(ByVal number As Int32, aliquotSum As UInt32) As Classification
        If (aliquotSum > number) Then Return Classification.Abundant
        If (aliquotSum < number) Then Return Classification.Deficient
        Return Classification.Perfect
    End Function

End Module
