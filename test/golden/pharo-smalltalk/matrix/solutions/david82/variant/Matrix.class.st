Class {
    #name : #Matrix,
    #superclass : #Object,
    #instVars : [ ],
    #classVars : [ ],
    #category : #'Exercise@Matrix',
    #package : #'Exercisf@Matrix'
}

{ #category : #private }
Matrix >> parseMatrix: matrixString [
    "Parse the matrix string into a 2D array of integers.
    Each line represents a row, numbers are separated by spaces."
    
    ^ (matrixString lines collect: [ :line |
        line substrings collect: [ :numberString | 
            numberString asInteger 
        ]
    ]) asArray
]

{ #category : #api }
Matrix >> input: matrixString atRow: rowNumber [
    "Extract the specified row from the matrix.
    Row numbers are 1-indexed."
    
    | parsedMatrix |
    
    parsedMatrix := self parseMatrix: matrixString.
    
    "Return the specified row as an array"
    ^ (parsedMatrix at: rowNumber) asArray
]

{ #category : #api }
Matrix >> input: matrixString atColumn: columnNumber [
    "Extract the specified column from the matrix.
    Column numbers are 1-indexed."
    
    | parsedMatrix |
    
    parsedMatrix := self parseMatrix: matrixString.
    
    "Extract the column by collecting the element at columnNumber from each row"
    ^ (parsedMatrix collect: [ :row | 
        row at: columnNumber 
    ]) asArray
]
