Red [
	description: {"Roman Numerals" exercise solution for exercism platform}
	author: "goran77" ; you can write your name here, in quotes
]

roman: function [arabic] [
	dict: [1 "I" 2 "II" 3 "III" 4 "IV" 5 "V" 6 "VI" 7 "VII" 8 "VIII" 9 "IX" 10 "X" 20 "XX" 30 "XXX" 40 "XL" 50 "L" 60 "LX" 70 "LXX" 80 "LXXX" 90 "XC" 100 "C" 200 "CC" 300 "CCC" 400 "CD" 500 "D" 600 "DC" 700 "DCC" 800 "DCCC" 900 "CM" 1000 "M" 2000 "MM" 3000 "MMM" 
]

arabic: to-string arabic
roman-num: copy ""

forall arabic [
    digit: (to-integer to-string first arabic) * (power 10 (length? arabic) - 1)
    if to-logic (select dict digit) [append roman-num select dict digit]
]
roman-num
]
