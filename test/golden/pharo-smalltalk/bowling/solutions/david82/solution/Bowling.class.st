Class {
    #name : #Bowling,
    #superclass : #Object,
    #instVars : [
        'rolls'
    ],
    #category : #'Exercise@Bowling'
}

{ #category : #initialization }
Bowling >> initialize [
    "Initialize the bowling game"
    super initialize.
    rolls := OrderedCollection new
]

{ #category : #private }
Bowling >> isStrike: rollIndex [
    "Check if the roll at given index is a strike"
    rollIndex + 1 <= rolls size ifFalse: [ ^ false ].
    ^ (rolls at: rollIndex + 1) = 10
]

{ #category : #private }
Bowling >> isSpare: rollIndex [
    "Check if the frame starting at given index is a spare"
    rollIndex + 2 <= rolls size ifFalse: [ ^ false ].
    ^ (rolls at: rollIndex + 1) + (rolls at: rollIndex + 2) = 10
]

{ #category : #private }
Bowling >> scoreFrame: frameIndex [
    "Calculate score for a single frame"
    | score |
    score := 0.
    
    "Check if it's a strike"
    (self isStrike: frameIndex) ifTrue: [
        score := 10 + (rolls at: frameIndex + 2) + (rolls at: frameIndex + 3).
        ^ score
    ].
    
    "Check if it's a spare"
    (self isSpare: frameIndex) ifTrue: [
        score := 10 + (rolls at: frameIndex + 3).
        ^ score
    ].
    
    "Open frame"
    score := (rolls at: frameIndex + 1) + (rolls at: frameIndex + 2).
    ^ score
]

{ #category : #private }
Bowling >> nextRollIndex: frameIndex [
    "Get the index for the next frame's first roll"
    (self isStrike: frameIndex) 
        ifTrue: [ ^ frameIndex + 1 ]
        ifFalse: [ ^ frameIndex + 2 ]
]

{ #category : #private }
Bowling >> isGameComplete [
    "Check if the game is complete and can be scored"
    rolls size = 0 ifTrue: [ ^ false ].
    ^ self canScoreAllFrames
]

{ #category : #private }
Bowling >> canScoreAllFrames [
    "Check if we have enough rolls to score all 10 frames"
    | rollIndex frame |
    rollIndex := 0.
    frame := 1.
    
    [ frame <= 10 ] whileTrue: [
        frame = 10 ifTrue: [
            "Special case for 10th frame"
            ^ self canScore10thFrame: rollIndex
        ].
        
        "Check if we can score this frame"
        (self canScoreFrame: rollIndex) ifFalse: [ ^ false ].
        
        "Move to next frame"
        rollIndex := self nextRollIndex: rollIndex.
        frame := frame + 1
    ].
    
    ^ true
]

{ #category : #private }
Bowling >> canScoreFrame: frameIndex [
    "Check if we have enough rolls to score the frame at given index"
    frameIndex + 1 > rolls size ifTrue: [ ^ false ].
    
    "If it's a strike, need 2 more rolls for bonus"
    (self isStrike: frameIndex) ifTrue: [
        ^ frameIndex + 3 <= rolls size
    ].
    
    "Otherwise need at least 2 rolls for the frame"
    frameIndex + 2 > rolls size ifTrue: [ ^ false ].
    
    "If it's a spare, need 1 more roll for bonus"
    (self isSpare: frameIndex) ifTrue: [
        ^ frameIndex + 3 <= rolls size
    ].
    
    "Open frame - we have what we need"
    ^ true
]

{ #category : #private }
Bowling >> canScore10thFrame: frameIndex [
    "Check if we can score the 10th frame"
    | rollCount firstRoll secondRoll |
    rollCount := rolls size.
    frameIndex + 1 > rollCount ifTrue: [ ^ false ].
    
    firstRoll := rolls at: frameIndex + 1.
    
    "If first roll is a strike, need 2 more rolls"
    firstRoll = 10 ifTrue: [
        ^ frameIndex + 3 <= rollCount
    ].
    
    "Need at least second roll"
    frameIndex + 2 > rollCount ifTrue: [ ^ false ].
    secondRoll := rolls at: frameIndex + 2.
    
    "If it's a spare, need 1 more roll"
    (firstRoll + secondRoll = 10) ifTrue: [
        ^ frameIndex + 3 <= rollCount
    ].
    
    "Open 10th frame - we have what we need"
    ^ true
]

{ #category : #private }
Bowling >> find10thFrameStart: rollsArray [
    "Find the starting index of the 10th frame"
    | rollIndex frame |
    rollIndex := 0.
    frame := 1.
    
    [ frame < 10 ] whileTrue: [
        "Move to next frame"
        rollIndex + 1 <= rollsArray size ifTrue: [
            (rollsArray at: rollIndex + 1) = 10 
                ifTrue: [ rollIndex := rollIndex + 1 ]
                ifFalse: [ rollIndex := rollIndex + 2 ]
        ] ifFalse: [
            rollIndex := rollIndex + 1
        ].
        frame := frame + 1
    ].
    
    ^ rollIndex
]

{ #category : #private }
Bowling >> isGameCompleteWithRolls: rollsArray [
    "Check if game would be complete with these rolls"
    | tempRolls result |
    tempRolls := rolls.
    rolls := rollsArray asOrderedCollection.
    result := self isGameComplete.
    rolls := tempRolls.
    ^ result
]

{ #category : #private }
Bowling >> validatePinCount: pins afterRolls: rollsArray [
    "Validate that pin count doesn't exceed available pins"
    | rollCount tenthFrameStart |
    rollCount := rollsArray size.
    
    "Find where 10th frame starts"
    tenthFrameStart := self find10thFrameStart: rollsArray.
    
    "If we're in the 10th frame"
    rollCount > tenthFrameStart ifTrue: [
        self validate10thFramePinCount: pins afterRolls: rollsArray
    ] ifFalse: [
        "Validate regular frames"
        self validateRegularFramePinCount: pins afterRolls: rollsArray
    ]
]

{ #category : #private }
Bowling >> validateRegularFramePinCount: pins afterRolls: rollsArray [
    "Validate pin count for regular frames (1-9)"
    | rollCount rollIndex frame |
    rollCount := rollsArray size.
    
    "Walk through frames to find current position"
    rollIndex := 0.
    frame := 1.
    
    [ frame <= 9 and: [ rollIndex < rollCount - 1 ] ] whileTrue: [
        rollIndex + 1 <= rollsArray size ifTrue: [
            (rollsArray at: rollIndex + 1) = 10 
                ifTrue: [ 
                    "Strike - move to next frame"
                    rollIndex := rollIndex + 1.
                    frame := frame + 1 
                ]
                ifFalse: [ 
                    "Not a strike - check if we have second roll"
                    rollIndex + 2 <= rollsArray size ifTrue: [
                        "Complete frame - validate and move to next"
                        | firstRoll secondRoll |
                        firstRoll := rollsArray at: rollIndex + 1.
                        secondRoll := rollsArray at: rollIndex + 2.
                        (firstRoll + secondRoll > 10) ifTrue: [
                            Error signal: 'Pin count exceeds pins on the lane'
                        ].
                        rollIndex := rollIndex + 2.
                        frame := frame + 1
                    ] ifFalse: [
                        "This is the second roll of current frame"
                        | firstRoll |
                        firstRoll := rollsArray at: rollIndex + 1.
                        (firstRoll + pins > 10) ifTrue: [
                            Error signal: 'Pin count exceeds pins on the lane'
                        ].
                        ^ self
                    ]
                ]
        ] ifFalse: [
            "Not enough rolls - shouldn't happen"
            ^ self
        ]
    ]
]

{ #category : #private }
Bowling >> validate10thFramePinCount: pins afterRolls: rollsArray [
    "Validate pin count for 10th frame"
    | rollCount tenthFrameStart frameRollIndex firstRoll secondRoll |
    rollCount := rollsArray size.
    tenthFrameStart := self find10thFrameStart: rollsArray.
    frameRollIndex := rollCount - tenthFrameStart.
    
    frameRollIndex = 1 ifTrue: [
        "First roll of 10th frame - no additional validation needed"
        ^ self
    ].
    
    firstRoll := rollsArray at: tenthFrameStart + 1.
    
    frameRollIndex = 2 ifTrue: [
        "Second roll of 10th frame"
        (firstRoll ~= 10 and: [ firstRoll + pins > 10 ]) ifTrue: [
            Error signal: 'Pin count exceeds pins on the lane'
        ]
    ].
    
    frameRollIndex = 3 ifTrue: [
        "Third roll of 10th frame"
        secondRoll := rollsArray at: tenthFrameStart + 2.
        
        "If first roll was strike, second and third are independent"
        firstRoll = 10 ifTrue: [
            (secondRoll ~= 10 and: [ secondRoll + pins > 10 ]) ifTrue: [
                Error signal: 'Pin count exceeds pins on the lane'
            ]
        ] ifFalse: [
            "If first wasn't strike but first + second = 10 (spare), third is independent"
            "No additional validation needed for third roll after spare"
        ]
    ]
]

{ #category : #private }
Bowling >> maxRollsForGame: rollsArray [
    "Calculate maximum rolls needed for this game"
    | tenthFrameStart firstRoll secondRoll |
    
    "If we don't have enough rolls to start 10th frame"
    tenthFrameStart := self find10thFrameStart: rollsArray.
    tenthFrameStart + 1 > rollsArray size ifTrue: [ ^ 21 ].
    
    "Check 10th frame requirements"
    firstRoll := rollsArray at: tenthFrameStart + 1.
    
    "If 10th frame starts with strike, need 3 rolls total"
    firstRoll = 10 ifTrue: [ ^ tenthFrameStart + 3 ].
    
    "Need at least second roll"
    tenthFrameStart + 2 > rollsArray size ifTrue: [ ^ 21 ].
    secondRoll := rollsArray at: tenthFrameStart + 2.
    
    "If it's a spare, need 3 rolls total"
    (firstRoll + secondRoll = 10) ifTrue: [ ^ tenthFrameStart + 3 ].
    
    "Open 10th frame needs exactly 2 rolls"
    ^ tenthFrameStart + 2
]

{ #category : #api }
Bowling >> scoreAfterRolling: rollsArray [
    "Calculate the total score after all rolls are complete"
    | totalScore rollIndex |
    
    "Set up the rolls"
    rolls := rollsArray asOrderedCollection.
    
    "Check if game is complete"
    (self isGameComplete) ifFalse: [
        Error signal: 'Score cannot be taken until the end of the game'
    ].
    
    totalScore := 0.
    rollIndex := 0.
    
    "Score first 9 frames"
    1 to: 9 do: [ :frame |
        totalScore := totalScore + (self scoreFrame: rollIndex).
        rollIndex := self nextRollIndex: rollIndex
    ].
    
    "Score 10th frame - just sum all remaining rolls"
    rollIndex + 1 to: rolls size do: [ :index |
        totalScore := totalScore + (rolls at: index)
    ].
    
    ^ totalScore
]

{ #category : #private }
Bowling >> validateFramePinCount: pins afterRolls: rollsArray [
    "Simplified validation for pin count in frames"
    | rollCount |
    rollCount := rollsArray size.
    
    "If we only have 1 or 2 rolls, we're definitely in the first frame"
    rollCount <= 2 ifTrue: [
        rollCount = 2 ifTrue: [
            "Second roll of first frame - check if sum exceeds 10"
            | firstRoll secondRoll |
            firstRoll := rollsArray at: 1.
            secondRoll := rollsArray at: 2.
            (firstRoll + secondRoll > 10) ifTrue: [
                Error signal: 'Pin count exceeds pins on the lane'
            ]
        ].
        ^ self
    ].
    
    "For more complex cases, use the existing validation"
    self validatePinCount: pins afterRolls: rollsArray
]

{ #category : #api }
Bowling >> scoreRolling: pins after: previousRolls [
    "Roll a ball and validate the move, then calculate score"
    | newRolls |
    
    "Validate the roll"
    pins < 0 ifTrue: [
        Error signal: 'Negative roll is invalid'
    ].
    
    pins > 10 ifTrue: [
        Error signal: 'Pin count exceeds pins on the lane'
    ].
    
    "Create new rolls array with the additional roll"
    newRolls := previousRolls asOrderedCollection copy.
    newRolls add: pins.
    
    "Check if game would be over after this roll"
    (self isGameCompleteWithRolls: previousRolls) ifTrue: [
        Error signal: 'Cannot roll after game is over'
    ].
    
    "Check if this roll would exceed the maximum allowed"
    newRolls size > (self maxRollsForGame: newRolls) ifTrue: [
        Error signal: 'Cannot roll after game is over'
    ].
    
    "Use simplified validation for simple cases, complex validation for others"
    self validateFramePinCount: pins afterRolls: newRolls.
    
    "Calculate and return score"
    ^ self scoreAfterRolling: newRolls
]
