Class {
    #name : #Die,
    #superclass : #Object,
    #instVars : [
        'faces'
    ],
    #category : #'Exercise@Die'
}

{ #category : #'instance creation' }
Die class >> withFaces: aNumber [
    ^ self new faces: aNumber; yourself
]

{ #category : #accessing }
Die >> faces [
    ^ faces
]

{ #category : #accessing }
Die >> faces: aNumber [
    faces := aNumber
]

{ #category : #initialization }
Die >> initialize [
    super initialize.
    faces := 7
]

{ #category : #printing }
Die >> printOn: aStream [
    super printOn: aStream.
    aStream nextPutAll: ' (', faces printString, ')'
]

{ #category : #public }
Die >> roll [
    ^ faces atRandom
]
