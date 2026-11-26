Class {
	#name : 'BinarySearchTree',
	#superclass : 'Object',
	#instVars : [
		'data',
		'left',
		'right'
	],
	#category : 'Exercise@BinarySearchTree',
	#package : 'Exercise@BinarySearchTree'
}

{ #category : 'private - functions' }
BinarySearchTree class >> inOrderTraverse: root collector: stream [
	root ifNotNil: [
		self inOrderTraverse: root left collector: stream.
		stream nextPut: root data.
		self inOrderTraverse: root right collector: stream.
	].
]

{ #category : 'instance creation' }
BinarySearchTree class >> new: data left: left right: right [
	| newNode |
	newNode := self new.
	newNode setData: data.
	newNode setLeft: left.
	newNode setRight: right.
	^ newNode.
]

{ #category : 'private - adcessing' }
BinarySearchTree >> data [
	^ data.
]

{ #category : 'private - accessing' }
BinarySearchTree >> left [
	^ left.
]

{ #category : 'private - accessing' }
BinarySearchTree >> right [
	^ right.
]

{ #category : 'private - writing' }
BinarySearchTree >> setData: d [
	data := d.
]

{ #category : 'private - writing' }
BinarySearchTree >> setLeft: l [
	left := l.
]

{ #category : 'private - writing' }
BinarySearchTree >> setRight: r [
	right := r.
]

{ #category : 'class' }
BinarySearchTree >> sortedData [
	| collector |
	collector := WriteStream on: Array new.
	self class inOrderTraverse: self collector: collector.
	^ collector contents.
]

{ #category : 'class' }
BinarySearchTree >> treeData: array [
	| currNode nodeInserted |
	left := nil.
	right := nil.
	array isEmpty ifTrue: [
		data := nil.
		^ self.
	].
	data := array first.
	array allButFirstDo: [ :elem |
		currNode := self.
		nodeInserted := false.
		[ nodeInserted ] whileFalse: [
			elem <= currNode data ifTrue: [
				currNode left ifNil: [
					currNode setLeft: (self class new: elem left: nil right: nil).
					nodeInserted := true.
				] ifNotNil: [
					currNode := currNode left.
				].
			] ifFalse: [
				currNode right ifNil: [
					currNode setRight: (self class new: elem left: nil right: nil).
					nodeInserted := true.
				] ifNotNil: [
					currNode := currNode right.
				].
			].
		].
 	].
	^ self.
]
