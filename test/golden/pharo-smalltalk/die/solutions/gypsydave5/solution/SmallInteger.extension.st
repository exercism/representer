Extension { #name : #SmallInteger }

{ #category : #'*Exercise@Die' }
SmallInteger >> d10 [
	^ DieHandle ofCount: self withFace: 10.
	
]

{ #category : #'*Exercise@Die' }
SmallInteger >> d20 [
	^ DieHandle ofCount: self withFace: 20.
	
]
