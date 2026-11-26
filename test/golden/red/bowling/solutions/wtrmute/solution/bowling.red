Red [
	description: {"Bowling" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

throws: copy []
; second throw is the second in a frame, where the pins haven't been just restored
second-throw: function [] [
	frame: [ set a integer! if (a = 10) | integer! integer! ]
    incomplete-frame: [ set a integer! if (a < 10) ]
    final-frame: [
    	  set a integer! if (a = 10) set b integer! if (b < 10) ; first bonus roll is not a strike, following roll is second
    	| set a integer! if (a < 10) ; didn't get a strike, following roll is second
    ]
    parse throws [ 0 9 frame incomplete-frame | 9 frame final-frame ]
]

game-in-progress: function [] [
	coalesce: function [ a b ][ either none? a [ b ][ a ] ]
	frame: [ set a integer! if (a = 10) | integer! integer! ]
    incomplete-frame: [ integer! ]
    final-incomplete-frame: [ set a integer! if (a = 10) opt integer!
    	| set a integer! set b opt integer! if (a + (coalesce b 0) = 10)
        | integer! ]
    parse throws [ 9 frame opt final-incomplete-frame
    	| 0 8 frame opt incomplete-frame ]
]

score: function [
	return: [integer!]
] [
	if game-in-progress [cause-error 'user 'message "Score cannot be taken until the end of the game"]
	points: 0
	frame: 1
	repeat frame 10 [
		f: take throws
		if f = 10 [
			; strike
			points: points + f + (first throws) + (second throws)
			continue
        ]
		s: take throws
		if f + s = 10 [
			; spare
			points: points + f + s + (first throws)
			continue
        ]
		; open frame
		points: points + f + s
    ]
	points
]

roll: function [
	pins [integer!]
] [
	if pins < 0 [cause-error 'user 'message "Negative roll is invalid"]
	if pins > (either second-throw [10 - last throws] [10]) [cause-error 'user 'message "Pin count exceeds pins on the lane"]
    unless game-in-progress [cause-error 'user 'message "Cannot roll after game is over"]
	append throws pins
]
