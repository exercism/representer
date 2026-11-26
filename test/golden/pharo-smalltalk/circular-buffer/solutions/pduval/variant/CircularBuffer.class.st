Class {
    #name: #CircularBuffer,
    #superclass: #Object,
    #instVars: [
        'buffer',
        'writePointer',
        'readPointer',
        'cap',
        'full'
    ],
    #category: #'Exercise@CircularBuffer'
}

CircularBuffer >> capacity: slots [
    buffer := Array new: slots.
    writePointer := 1.
    readPointer := 0.
    cap := slots.
    full := false.
]

CircularBuffer >> write: item [
    full
      ifFalse: [
          buffer at: (writePointer + 1) put: item.
          writePointer := ((writePointer + 1) \\\ cap).
          full := (writePointer = readPointer).
      ]
      ifTrue: [
          self error: 'Buffer is full'.
      ]
]

CircularBuffer >> read [
    |res|
    ((writePointer = readPointer) and: (full = false)) ifTrue: [
        self error: 'Cannot read empty buffer'.
    ].
    res := (buffer at: (readPointer + 1)).
    readPointer := (readPointer + 1) \\\ cap.
    full := false.
    ^ res
]

CircularBuffer >> clear [
    full := false.
    writePointer := 0.
    readPOinter := 0.
]

CircularBuffer >> overwrite: item [
    full
       ifFalse: [
           ^ self write: item
       ]
       ifTrue: [
          buffer at: (writePointer + 1) put: item.
          writePointer := ((writePointer + 1) \\\ cap).
          readPointer := writePointer.
       ]
]