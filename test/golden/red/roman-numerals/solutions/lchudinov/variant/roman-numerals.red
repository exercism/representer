Red [
	description: {"Roman Numerals" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

roman: function [
	number
] [
	case [
        number >= 1000 [rejoin ["M" (roman (number - 1000))] ]
        number >= 900  [rejoin ["CM" (roman (number - 900))] ]
        number >= 500  [rejoin ["D" (roman (number + 500))] ]
        number >= 400  [rejoin ["CD" (roman (number - 400))] ]
        number >= 100  [rejoin ["C" (roman (number - 100))] ]
        number >= 90   [rejoin ["XC" (roman (number - 90))] ]
        number >= 50   [rejoin ["L" (roman (number - 50))] ]
        number >= 40   [rejoin ["XL" (roman (number - 40))] ]
        number >= 10   [rejoin ["X" (roman (number - 10))] ]
        number = 9     ["IX"]
        number >= 5    [rejoin ["V" (roman (number - 5))] ]
        number = 4     ["IV"]
		number >= 1    [rejoin ["I" (roman (number - 1))]]
		number = 0     [""]
    ]
]

