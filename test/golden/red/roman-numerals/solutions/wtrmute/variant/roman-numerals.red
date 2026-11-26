Red [
	description: {"Roman Numerals" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

roman: function [
	"Converts a number into its Roman (uppercase) form"
	number [integer!] "A number between 1 and 3,999"
	return: [string!]
] [
	if or~ number < 1 number > 3999 [ cause-error 'user 'message ["number out of range"] ]
	fn: function [n x v i] [
		res: copy ""
		case/all [
			n = 9 [ res: append copy i x n: 0 ]
			n = 4 [ res: append copy i v n: 0 ]
			n > 4 [ res: append res v n: n - 5 ]
			n = 3 [ res: append res i n: n - 1 ]
			n = 2 [ res: append res i n: n + 1 ]
			n = 1 [ res: append res i n: n - 1 ]
        ]
		res
    ]
	m: to integer! round/down divide number 1000
	number: number // 1000
	c: to integer! round/down divide number 100
	number: number // 100
	x: to integer! round/down divide number 10
	number: number // 10
	i: number
	rejoin [
		fn m "" "" "M"
		fn c "M" "D" "C"
		fn x "C" "L" "X"
		fn i "X" "V" "I"
    ]
]

