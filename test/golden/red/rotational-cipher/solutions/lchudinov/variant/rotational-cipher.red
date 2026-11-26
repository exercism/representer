Red [
	description: {"Rotational Cipher" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

rotate: function [
	text
	shiftKey
] [
	alphabet: "abcdefghijklmnopqrstuvwxyz"
    total: length? alphabet
    result: ""
    foreach [ch] text [
		place: find alphabet ch
		either none? place [
                append result ch
        ] [
            index: (index? place) + shiftKey
            if index > total [index: index % (total - 1) + 1]
			append result (pick alphabet index) 
        ]
    ]
    result
]



