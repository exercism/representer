Red [
	description: {"Run Length Encoding" exercise solution for exercism platform}
	author: ""
]

encode: function [
	string
] [
	prev: none
	n: 0
	res: ""
	foreach c string [
		either c = prev [
			n: n + 1
        ][
			case [
				n = 0 []
				n = 1 [append res prev]
				n > 1 [append res to integer! n append res prev]
            ]
			prev: c
			n: 1
        ]
    ]
    case [
    	n = 0 []
    	n = 1 [append res prev]
    	n > 1 [append res to integer! n append res prev]
    ]
	res
]

decode: function [
	string
] [
	n: 0
	res: ""
	foreach c string [
		either #"0" < c and (c <= #"9") [
			n: 10 * n + to integer! c - to integer! #"0"
        ][
			loop n [append res c]
			if n = 0 [append res c]
			n: 0
        ]
    ]
	res
]
