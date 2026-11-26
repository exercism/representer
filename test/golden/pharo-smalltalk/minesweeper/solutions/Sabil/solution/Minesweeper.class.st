Class {
	#name : #Minesweeper,
	#superclass : #Object,
	#category : #'Exercise@Minesweeper'
}

Minesweeper >> annotateMinefield: aCollection [
	^ (Board fromStrings: aCollection) annotatedStrings
]
