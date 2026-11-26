Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #printing }
TwoFer >> who [
	^ self who: 'you'
]

{ #category : #printing }
TwoFer >> who: aString [ 
	
	^ String streamContents: [:aStream |
		aStream
		nextPutAll: 'One for ';
		nextPutAll: aString;
		nextPutAll: ', one for me.'
		 ]
]
